require "bundler/gem_tasks"

namespace :db do
  task :environment do
    require 'active_record'
    require 'logger'

    DB_CONFIG = YAML.load_file("database.yml")

    ActiveRecord::Base.establish_connection(
      :adapter  => DB_CONFIG['adapter'],
      :database => DB_CONFIG['database']
    )
  end

  desc "Migrate the database"
  task(:migrate => :environment) do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end
end
