require 'qiniu'
require 'yaml'
class Entry < ActiveRecord::Base
  default_scope { order('id DESC') }
  scope :today, -> { where(happend_at: Time.new.beginning_of_day()..Time.new.end_of_day()) }
  scope :dgtle, -> { where(source: 'dgtle') }
  scope :fengniao, -> { where(source: 'fengniao') }
  scope :macx, -> { where(source: 'macx') }
  scope :v2ex, -> { where(source: 'v2ex') }
  scope :weiphone, -> { where(source: 'weiphone') }

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
      return if self.uploaded
      self.images.each do |img|
        code, result, response_headers = Qiniu::Storage.upload_with_put_policy(
          put_policy,
          "./public#{img.img_link}",
          "pd_images/#{img.img_name}"
        )

        if code == 200 and result
          img.update!(img_link: "#{qiniu['ServerUrl']}#{result['key']}")
        end
      end
      self.update!(uploaded: true)
    rescue => e
      puts "upload image into qiniu error: #{e}"
      return
    end
  end

  private
  def add_html_tag(content)
    return "" if content.blank?

    ary = content.strip.split("\n")

    if ary.size > 0
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
