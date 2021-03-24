class InviteEmailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(id)
    person = Person.find(id)
    InviteMailer.with(person: person).invitation_email.deliver
  end
end
