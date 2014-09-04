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
require 'qiniu'

dbconfig = YAML::load(File.open('./config/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig["development"])

def update_entry_img(entry)
  if entry.img.nil? && entry.images.size > 0
    image = entry.images.first
    entry.img_name = image.img_name
    entry.img = image.img_link + "?imageView/1/w/160/h/120/q/85"
    entry.save
  end
end

def has_imgs?(content)
  return unless content
  count = 0
  content.css('img').each do |img|
    file = img.attributes["file"]
    count += 1 if file and (file.value.end_with?(".jpg") or file.value.end_with?(".png"))
  end
  count > 0
end

# for upload image to qiniu
# kind   : pd_images or en_images
def save_img_by_qiniu(name, kind)
  begin
    settings = YAML::load(File.open('./config/application.yml'))
    qiniu = settings['production']['qiniu']
    Qiniu.establish_connection! :access_key => qiniu['AccessKey'],
                                :secret_key => qiniu['SecretKey']
    put_policy = Qiniu::Auth::PutPolicy.new(
      "estao",     # 存储空间
    )

    uptoken = Qiniu::Auth.generate_uptoken(put_policy)

    code, result, response_headers = Qiniu::Storage.upload_with_put_policy(
      put_policy,
      "./public/#{kind}/#{name}",
      "#{kind}/#{name}"
    )

    if code == 200 and result
      return "#{qiniu['ServerUrl']}#{result['key']}"
    else
      return nil
    end
  rescue => e
    puts "upload image into qiniu error: #{e}"
    return nil
  end
end
