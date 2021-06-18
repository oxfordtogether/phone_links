class ReportReceivedMailer < ApplicationMailer
  def report_received_email(report, pod, recipient)
    @report = report
    @pod = pod
    @recipient = recipient
    @site_url = ENV["SITE_URL"] || Rails.application.credentials.site_url

    mail(to: clean_email(recipient.email), subject: "Oxford Hub Phone Links: Report Submitted")
  end

  private

  def clean_email(email)
    email.downcase.strip
  end
end
