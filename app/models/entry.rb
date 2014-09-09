require 'qiniu'
require 'yaml'
class Entry < ActiveRecord::Base
  default_scope { order('id DESC') }
  scope :today, -> { where(happend_at: Time.new.beginning_of_day()..Time.new.end_of_day()) }
  scope :legacy, -> { where("created_at < ?", Time.now.beginning_of_month()) }
  scope :not_deleted, -> { where.not(status: Entry.statuses[:deleted]) }
  scope :dgtle, -> { where(source: 'dgtle') }
  scope :fengniao, -> { where(source: 'fengniao') }
  scope :macx, -> { where(source: 'macx') }
  scope :v2ex, -> { where(source: 'v2ex') }
  scope :weiphone, -> { where(source: 'weiphone') }

  enum status: { normal: 0, uploaded: 1, deleted: 9 }

  has_many :images, dependent: :destroy

  def self.summary
    array = []
    array << {source: 'dgtle', num: Entry.today.dgtle.count }
    array << {source: 'fengniao', num: Entry.today.fengniao.count }
    array << {source: 'weiphone', num: Entry.today.weiphone.count }
    array << {source: 'macx', num: Entry.today.macx.count }
    array << {source: 'v2ex', num: Entry.today.v2ex.count }

    return array
  end

  def full_content
    add_html_tag(content).concat(add_img_tag)
  end

  def upload_to_qiniu
    settings = YAML::load(File.open('./config/application.yml'))
    qiniu = settings['production']['qiniu']
    Qiniu.establish_connection! :access_key => qiniu['AccessKey'],
                                :secret_key => qiniu['SecretKey']
    put_policy = Qiniu::Auth::PutPolicy.new(
      "estao",     # 存储空间
    )

    uptoken = Qiniu::Auth.generate_uptoken(put_policy)

    begin
      return if self.uploaded?
      self.images.each do |img|
        image_link = "./public#{img.img_link}"
        code, result, response_headers = Qiniu::Storage.upload_with_put_policy(
          put_policy,
          image_link,
          "pd_images/#{img.img_name}"
        )

        if code == 200 and result
          img.update!(img_link: "#{qiniu['ServerUrl']}#{result['key']}")
          File.delete(image_link) if File::exists?(image_link)
        end
      end
      self.update!(status: Entry.statuses[:uploaded])
    rescue => e
      puts "upload image into qiniu error: #{e}"
      return
    end
  end

  def self.clean
    settings = YAML::load(File.open('./config/application.yml'))
    qiniu = settings['production']['qiniu']
    access_key = qiniu['AccessKey'] || Settings.qiniu.AccessKey
    secret_key = qiniu['SecretKey'] || Settings.qiniu.SecretKey
    Qiniu.establish_connection! :access_key => access_key,
                                :secret_key => secret_key

    Entry.not_deleted.legacy.each do |e|
      if e.uploaded?
        e.images.each do |img|
          code, result, response_headers = Qiniu::Storage.delete(
            "estao",
            "pd_images/#{img.img_name}"
          )
          img.try(:destroy) if code == 200
        end
      elsif e.normal?
        e.images.each do |img|
          image_link = "./public#{img.img_link}"
          File.delete(image_link) if File::exists?(image_link)
          img.try(:destroy)
        end
        e.update!(status: Entry.statuses[:deleted])
      end
    end
  end

  private
  def add_html_tag(content)
    return "" if content.blank?

    ary = content.strip.split("\n")

    if ary.present? and ary.size > 0
      ary.map! do |ele|
        "<p>#{ele.strip}</p>"
      end
      ary.join("")
    else
      "<p>#{content}</p>"
    end
  end

  def add_img_tag
    img_tags = images.map do |img|
      "<a class='fancybox' rel=\"entry_#{self.id}\" href=\"#{img.img_link}\"><img src=\"#{img.img_link}\" /></a>"
    end
    img_tags.join("")
  end
end
