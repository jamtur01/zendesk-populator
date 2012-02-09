require 'sinatra'
require 'haml'
require 'sass'
require 'fastercsv'
require 'active_record'
require 'yaml'

require 'csv'
if CSV.const_defined? :Reader
  # Ruby 1.8
  require 'fastercsv'
  CSVKLASS = FasterCSV
else
  # Ruby 1.9, FasterCSV merged in stdlib
  CSVKLASS = CSV
end

def load_configuration(file, name)
  if !File.exist?(file)
    puts "There's no configuration file at #{file}!"
    exit!
  end
  const_set(name, YAML.load_file(file))
end

module ZendeskPopulator
  class Application < Sinatra::Base

    configure do
      load_configuration("config.yml", "APP_CONFIG")
      load_configuration("database.yml", "DB_CONFIG")

      ActiveRecord::Base.establish_connection(
        :adapter  => DB_CONFIG['adapter'],
        :database => DB_CONFIG['database']
      )
    end

    set :public_folder, File.join(File.dirname(__FILE__), 'public')
    set :views, File.join(File.dirname(__FILE__), 'views')

    class User < ActiveRecord::Base
      validates_presence_of :company,:name,:email
      validates_uniqueness_of :email
      validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
    end

    before do
      @app_name = "Zendesk Populator"
    end

    get '/' do
      flash_message(params[:m])
      erb :index
    end

    post '/create' do
      redirect "/?m=blank" if params[:email].blank?

      if User.count(:conditions => { :email => params[:email] }) > 0
        redirect "/?m=email_taken"
      end

      @user = User.new(:company  => params[:company],
                       :name     => params[:name],
                       :email    => params[:email],
                       :referer  => params[:referer])
      if @user.save
        redirect "/?m=success"
      else
        redirect "/?m=invalid"
      end
    end

    get '/backstage' do
      protected!
      @user_count = User.count
      erb :backstage
    end

    get '/backstage/csv' do
      protected!
      csv_content = FasterCSV.generate do |csv|
        User.find_each do |user|
          csv << [user.company, user.name, user.email]
        end
      end

      headers "Content-Disposition" => "attachment;filename=newusers.csv",
              "Content-Type" => "text/csv"
      csv_content
    end

    helpers do

      def flash_message(message)
        case message
        when "blank"
          @notice = "You need to specify a company name, the new user's full name and an email address."
        when "email_taken"
          @notice = "You've already added that user."
        when "email_invalid"
          @notice = "The format of the email address seems odd."
        when "success"
          @success = "Thank you! New user added!"
        else ""
        end
      end

      def pluralize(count, singular, plural = nil)
        "#{count || 0} " + ((count == 1 || count =~ /^1(\.0+)?$/) ? singular : (plural || singular.pluralize))
      end

      def testing?
        ENV['RACK_ENV'] == "test"
      end

      def protected!
        unless authorized?
          response['WWW-Authenticate'] = %(Basic realm="Authentication Required")
          throw(:halt, [401, "Not authorized\n"])
        end
      end

      def authorized?
        return true if testing?
        @auth ||=  Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [APP_CONFIG["admin_username"], APP_CONFIG["admin_password"]]
      end
    end
  end
end
