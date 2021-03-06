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
      begin
        ActiveRecord::Base.connection.drop_database(db_name)
      rescue StandardError
        nil
      end

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
      ENV['TRAVIS_DB_USER'] ? 'travis' : 'root'
    end

    def db_password
      ENV['TRAVIS_DB_PASSWORD'] ? '' : 'root'
    end

    def db_name
      'api_queries_test'
    end
  end
end

include Db::MySQL

drop_and_create_database # unless ENV['TRAVIS']

connect_db

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.integer :account_id
    t.string :name
    t.string :status, default: 'active'
    t.timestamps null: false
  end

  create_table :products do |t|
    t.string :name
    t.string :status, default: 'active'
  end

  create_table :accounts do |t|
    t.string :name
    t.timestamps
  end
end

# User Model
class User < ActiveRecord::Base
  include ApiQueries
  belongs_to :account
end

# Product Model
class Product < ActiveRecord::Base
  include ApiQueries
end

# Account Model
class Account < ActiveRecord::Base
  include ApiQueries
  has_many :users
end
