require 'dm-core'
require 'dm-migrations'

# DataMapper setup for Heroku should be set as ENV['DATABASE_URL'] as it is
# not using sqlite
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/models/database.db") if development?
DataMapper::setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/models/database.db") if production?

# Student class with id as primary key
class Student
  include DataMapper::Resource
  property :id, Serial
  property :sid, String, :required=>true
  property :firstname, String, :required=>true
  property :lastname, String, :required=>true
  property :birthday, Date, :required=>true
  property :address, String
end

# Comment class with id as primary key
class Comment
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :required=>true
  property :content, String, :required=>true
  property :created_at, String, :required=>true
end

# Account class for user account, using username as primary key
class Account
  include DataMapper::Resource
  property :name, String, :required=>true, :key=>true
  property :password, String, :required=>true
end

DataMapper.finalize
DataMapper.auto_upgrade!
