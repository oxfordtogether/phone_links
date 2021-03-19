class InviteEmailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(person)
    InviteMailer.with(person).invitation_email.deliver_later
  end
end
