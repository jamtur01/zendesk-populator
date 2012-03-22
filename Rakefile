namespace :db do
  task :environment do
    require 'rubygems'
    require 'active_record'
    require 'logger'

    DB_CONFIG = YAML::load(File.open('config/database.yml'))

    ActiveRecord::Base.establish_connection(
      :adapter  => DB_CONFIG['production']['adapter'],
      :database => DB_CONFIG['production']['database']
    )
  end

  desc "Migrate the database"
  task(:migrate => :environment) do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end
end
