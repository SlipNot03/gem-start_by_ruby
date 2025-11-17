require 'rake'
require 'sequel'
require 'uri'
require_relative 'config/db_config'

Sequel.extension :migration
task :connect_db do
  DB = Sequel.connect(DATABASE_URL)
  DB.loggers << Logger.new($stdout)
end

namespace :db do

  task :create do
    begin
      uri = URI.parse(DATABASE_URL)
      db_name, user, password, host = uri.path.delete_prefix('/'), uri.user, uri.password, uri.host
      admin_db = Sequel.connect(adapter: 'postgres', host: host, user: user, password: password, database: 'postgres')
      admin_db.run("CREATE DATABASE \"#{db_name}\"")
      admin_db&.disconnect
    end
  end

  task :drop do
    begin
      uri = URI.parse(DATABASE_URL)
      db_name  = uri.path.delete_prefix('/')
      user     = uri.user
      password = uri.password
      host     = uri.host
      admin_db = Sequel.connect(adapter: 'postgres', host: host, user: user, password: password, database: 'postgres')
      admin_db["SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = ?", db_name].all
      admin_db.run("DROP DATABASE \"#{db_name}\"")
      admin_db&.disconnect
    end
  end

  task migrate: :connect_db do
    Sequel::Migrator.run(DB, MIGRATIONS_PATH, use_transactions: true)
  end

  task rollback: :connect_db do
    Sequel::Migrator.run(DB, MIGRATIONS_PATH, target: 0, use_transactions: true)
  end

end