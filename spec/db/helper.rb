require_relative '../spec_helper'
# Establish database connection for rspec
module Db
  # db is MySQL
  module MySQL
    def connect_db
      ActiveRecord::Base.establish_connection(db_config)
    end

    def drop_and_create_database
      temp_connection = db_config.merge(database: 'mysql')

      ActiveRecord::Base.establish_connection(temp_connection)

      # drop existing db if exists
      ActiveRecord::Base.connection.drop_database(db_name) rescue nil

      # create new db
      ActiveRecord::Base.connection.create_database(db_name)
    end

    def db_config
      @db_config ||= {
        adapter:   'mysql2',
        database:  db_name,
        username:  db_user,
        password: db_password
      }
    end

    def db_user
      ENV['TRAVIS_DB_USER'] ? 'travis_user' : 'root'
    end

    def db_password
      ENV['TRAVIS_DB_PASSWORD'] ? 'travis_password' : 'root'
    end

    def db_name
      'api_queries_test'
    end
  end
end

include Db::MySQL

drop_and_create_database

connect_db

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :name
    t.string :status, default: 'active'
    t.timestamps null: false
  end
end

# Model
class User < ActiveRecord::Base
  include ApiQueries
end
