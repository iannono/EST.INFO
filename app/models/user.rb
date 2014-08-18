class User < ActiveRecord::Base
  validates_uniqueness_of :email
  #after_create :send_welcome_email

  def send_welcome_email
    UserMailer.delay.welcome(self)
  end
end
