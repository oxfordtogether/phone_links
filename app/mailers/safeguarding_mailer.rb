class SafeguardingMailer < ApplicationMailer
  def safeguarding_email
    @safeguarding_concern = params[:safeguarding_concern]

    safeguarding_admin = ENV["SAFEGUARDING_ADMIN"] || Rails.application.credentials.safeguarding_admin

    mail(to: clean_email(safeguarding_admin), subject: "Phone Links: Safeguarding Concern Submitted") if safeguarding_admin.present?

    safeguarding_lead = @safeguarding_concern&.person&.pod&.safeguarding_lead
    mail(to: clean_email(safeguarding_lead.email), subject: "Phone Links: Safeguarding Concern Submitted") if safeguarding_lead&.email.present?
  end

  private

  def clean_email(email)
    email.downcase.strip
  end
end
