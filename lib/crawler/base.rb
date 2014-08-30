require 'nokogiri'
require 'mechanize'
require 'open-uri'
require 'date'
require 'yaml'
require 'active_record'
require 'delayed_job_active_record'
require 'mini_magick'
require './app/models/entry'
require './app/models/image'
require './lib/robots/twitter'

dbconfig = YAML::load(File.open('./config/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig["development"])

def update_entry_img(entry)
  if entry.img.nil? && entry.images.size > 0
    image = entry.images.first 
    image_name = create_img_name 
    img_link = convert_image(image.img_link, image_name)

    entry.img_name = image_name
    entry.img = img_link
    entry.save
  end
end

def has_imgs?(content)
  return unless content
  (content.css('img').try(:count) || 0) > 0
end

private
def convert_image(link, name)
  image = MiniMagick::Image.open("./public#{link}")
  image.resize "160x120"
  image_link = "/en_images/#{name}"
  image.write "./public#{image_link}"
  return image_link
end

def create_img_name
  "#{SecureRandom.hex(4)}.png"
end
