class UserMailer < ActionMailer::Base
  default from: Settings.mailer.sender_address

  def welcome(user)
    @user = user

    mail to: user.email, subject: "Welcome to Estao!"
  end

  def reminder(user, entries)
    @entries = entries

    mail to: user.email, subject: "Estao.info"
  end
end
