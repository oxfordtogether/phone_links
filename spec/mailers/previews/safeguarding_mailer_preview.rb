# Preview all emails at http://localhost:3000/rails/mailers/safeguarding_mailer
class SafeguardingMailerPreview < ActionMailer::Preview
  def new_safeguarding_email
    safeguarding_lead = Person.new(first_name: "Janet", last_name: "Johnson", email: "janet@johnson.com")
    pod = Pod.new(name: "A", safeguarding_lead: safeguarding_lead)

    callee = Callee.new(person_attributes: {first_name: "John", last_name: "Smith"}, pod: pod, status: 'active')

    created_by = Person.new(first_name: "James", last_name: "Jones", email: "james@jones.com")

    safeguarding_concern = SafeguardingConcern.new(person: callee.person, status: "unread", created_by: created_by, concerns: "test")

    SafeguardingMailer.with(safeguarding_concern: safeguarding_concern).safeguarding_email
  end
end
