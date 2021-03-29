# Preview all emails at http://localhost:3000/rails/mailers/invite_mailer
class InviteMailerPreview < ActionMailer::Preview
  def new_invite_email
    person = Person.new(first_name: "John", last_name: "Smith", email: "john@smith.com")

    InviteMailer.with(person: person).invitation_email
  end
end
