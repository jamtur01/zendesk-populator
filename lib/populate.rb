require 'util'
require 'uri'
require 'httparty'

module ZendeskPopulator
  class Populate

    include ZendeskPopulator::Util

    def initialize(data)
      config
      if data[:dfile]
        accounts = load_data(data[:dfile])
        accounts.each { |a|
          create(a)
        }
      else
        create(data)
      end
    end

    def config
      @site = APP_CONFIG["zendesk_site"]
      @site = valid_site(@site)
      @user = APP_CONFIG["zendesk_user"]
      @password = APP_CONFIG["zendesk_password"]
      raise "Missing Zendesk site, user or password" if [ @site, @user, @password ].include?(nil)
    end

    def build_url(action)
      case action
      when :list_orgs
        "#{@site}/api/v1/organizations.json"
      when :list_users
        "#{@site}/api/v1/users.json"
      when :create_org
        "#{@site}/api/v1/organizations.json"
      when :create_user
        "#{@site}/api/v1/users.json"
      end
    end

    def get_party(url)
      response = HTTParty.get(url, :basic_auth => {:username=>"#{@user}", :password=> "#{@password}" } )
      reply(response)
    end

    def post_party(url,payload)
      response = HTTParty.post(url, :basic_auth => {:username=>"#{@user}", :password=> "#{@password}" }, :body => payload )
      reply(response)
    end

    def reply(response)
      case response.code
      when 200,201
        puts "All good!"
        response
      when 401
        raise "Oh dear - you ain't authorized"
      when 404
        raise "O noes not found!"
      when 500...600
        raise "ZOMG ERROR #{response.code}"
      end
    end

    def create(data)
      if data.is_a? Array
        org, name, email = data[0], data[1], data[2]
      elsif data.is_a? Hash
        org, name, email = data["company"], data["name"], data["email"]
      else
        raise "No properly formatted data found in #{data}"
      end
      domain = email.gsub(/^.*\@(.*)$/, '\1')
      orglist = list_orgs
      userlist = list_users
      unless orglist.include?(org)
        create_org(org,domain)
      end
      unless userlist.include?(name)
        create_user(name,email,org)
      end
    end

    def list_orgs
      orglist = []
      url = build_url(:list_orgs)
      organizations = get_party(url)
      organizations.each { |o|
          orglist << o["name"]
      }
      return orglist
    end

    def lookup_org_id(org)
      orgtable = {}
      url = build_url(:list_orgs)
      organizations = get_party(url)
      organizations.each { |o|
        orgtable["#{o["name"]}"] = o["id"]
      }
      id = orgtable["#{org}"]
      return id
    end

    def list_users
      userlist = []
      url = build_url(:list_users)
      users = get_party(url)
      users.each { |u|
        userlist << u["name"]
      }
      return userlist
    end

    def create_org(org,domain)
      payload = { :organization => { :name => org, :is_shared => 'true', :is_shared_comments => 'true', :default => domain } }
      url = build_url(:create_org)
      post_party(url,payload)
    end

    def create_user(name,email,org)
      id = lookup_org_id(org)
      payload = { :user => { :name => name, :email => email, :roles => '0', :restriction_id => '2', :organization_id => id } }
      url = build_url(:create_user)
      post_party(url,payload)
    end
  end
end
