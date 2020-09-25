# frozen_string_literal: true

# UserMailer sends reminders
class UserMailer < ApplicationMailer
  def reminder_email(email)
    @url = 'https://prempicks-web.vercel.app/'
    mail(to: email, subject: "Don't Forget to Pick!")
  end
end
