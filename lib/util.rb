require 'csv'
require 'yaml'

module ZendeskPopulator
  module Util
    def load_configuration(file, name)
      if !File.exist?(file)
        puts "There's no configuration file at #{file}!"
        exit!
      end
      ZendeskPopulator.const_set(name, YAML.load_file(file))
    end

    def load_data(file)
      if !File.exist?(file)
        puts "There's no data file at #{file}!"
        exit!
      else
        data = CSV.read(file)
        if data == []
          puts "No Zendesk data loaded - file empty"
          exit!
        else
          return data
        end
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
