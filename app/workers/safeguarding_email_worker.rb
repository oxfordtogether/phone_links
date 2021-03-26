class SafeguardingEmailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(id)
    safeguarding_concern = SafeguardingConcern.find(id)
    SafeguardingMailer.with(safeguarding_concern: safeguarding_concern).invitation_email.deliver
  end
end
