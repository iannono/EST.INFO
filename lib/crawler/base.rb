require 'nokogiri'
require 'mechanize'
require 'open-uri'
require 'date'
require 'yaml'
require 'active_record'
require 'delayed_job_active_record'
require './app/models/entry'
require './app/models/image'
require './lib/robots/twitter'

dbconfig = YAML::load(File.open('./config/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig["development"])
