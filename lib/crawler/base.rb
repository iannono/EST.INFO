require 'yaml'
require 'active_record'
require './app/models/entry'

dbconfig = YAML::load(File.open('./config/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig["production"])
