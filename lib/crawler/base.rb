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

def update_entry_img(entry)
  if entry.img.nil? && entry.images.size > 0
    image = entry.images.first
    entry.img = image.img_link
    entry.img_name = image.img_name
    entry.save
  end
end

def has_imgs?(content)
  return unless content
  (content.css('img').try(:count) || 0) > 0
end
