class InviteMailer < ApplicationMailer
  def invitation_email
    @person = params[:person]
    @signup_link = ENV["SIGNUP_LINK"] || Rails.application.credentials.signup_link

    mail(to: clean_email(@person.email), subject: "You've been invited to Oxford Hub Phone Links!")
  end

  private

  def clean_email(email)
    email.downcase.strip
  end
end
