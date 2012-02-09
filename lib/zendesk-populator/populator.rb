require 'yaml'
require 'csv'
require 'uri'

begin
  require 'httparty'
rescue LoadError => e
  puts "You need the `httparty` gem to use the Zendesk Populator"
end

module Zdpop
  class Populator

    def initialize(options)
      begin
        # Process options
        configfile = options[:cfile]
        datafile = options[:dfile]

        # Set configuration
        raise "Configuration file #{configfile} missing" unless File.file? configfile
        config = YAML.load_file(configfile)
        @site = valid_site(config[:zendesk_site])
        @user = config[:zendesk_user]
        @password = config[:zendesk_password]
        raise "Missing Zendesk site, user or password" if [ @site, @user, @password ].include?(nil)

        # Load data
        raise "Data file #{datafile} missing" unless File.file? datafile
        data = CSV.read(datafile)
        raise "No Zendesk data loaded - file empty" unless data != []
        create(data)
      rescue Exception => e
        puts e.message
      end
    end

    def create(data)
      orglist = list_orgs
      userlist = list_users
      data.each { |d|
        org = d[0]
        name = d[1]
        email = d[2]
        domain = email.gsub(/^.*\@(.*)$/, '\1')
        unless orglist.include?(org)
          create_org(org,domain)
        end
        unless userlist.include?(name)
          create_user(name,email,org)
        end
      }
    end

    def list_orgs
      orglist = []
      organizations = get_orgs
      organizations.each { |o|
          orglist << o["name"]
      }
      return orglist
    end

    def lookup_org_id(org)
      orgtable = {}
      organizations = get_orgs
      organizations.each { |o|
        orgtable["#{o["name"]}"] = o["id"]
      }
      id = orgtable["#{org}"]
      return id
    end

    def get_orgs
      HTTParty.get("#{@site}/api/v1/organizations.json", :basic_auth => {:username=>"#{@user}", :password=> "#{@password}" } )
    end

    def list_users
      userlist = []
      users = HTTParty.get("#{@site}/users.json", :basic_auth => {:username=>"#{@user}", :password=> "#{@password}" } )
      users.each { |u|
        userlist << u["name"]
      }
      return userlist
    end

    def create_org(org,domain)
      payload = { :organization => { :name => org, :is_shared => 'true', :is_shared_comments => 'true', :default => domain } }
      response = HTTParty.post("#{@site}/api/v1/organizations.json", :basic_auth => {:username=>"#{@user}", :password=> "#{@password}" }, :body => payload )
      if response.code == 201
        puts "Created organization #{org}"
      else
        puts "Response code: #{response.code} - #{response.body}"
      end
    end

    def create_user(name,email,org)
      id = lookup_org_id(org)
      payload = { :user => { :name => name, :email => email, :roles => '0', :restriction_id => '2', :organization_id => id } }
      response = HTTParty.post("#{@site}/users.json", :basic_auth => {:username=>"#{@user}", :password=> "#{@password}" }, :body => payload )
      if response.code == 200
        puts "Created user #{name}"
      else
        puts "Response code: #{response.code} - #{response.body}"
      end
    end

    def valid_site(site)
      begin
        uri = URI.parse(site.gsub(/\/*$/,''))
        if uri.class != URI::HTTPS
          puts "Only HTTPS protocol addresses can be used"
        end
        return uri
      rescue URI::InvalidURIError
        puts "The site: #{site} is not a valid URL"
      end
    end
  end
end
