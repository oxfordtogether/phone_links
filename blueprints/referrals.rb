referral do |ref|
  ref.namespace :referrer do |p|
    p.name
    p.phone
    p.email
    p.string :org_and_role, encrypted: true
  end

  ref.namespace :referred do |p|
    p.name
    p.phone
    p.email optional: true
    p.address
    p.options :age_range, { age_18_35: "18-35", age_36_59: "36-59", age_60_74: "60-74", age_75_plus: "75+" }
  end

  ref.text :reason_for_referral, encrypted: true, description: "Reason for referral"
  ref.options :living_arrangements, {}
  ref.boolean :calls_in_english
  ref.string :language, if: "calls_in_english:false"

  ref.text :interests
  ref.text :additional_needs
  ref.boolean :from_elmore

  ref.date_of_birth

  ref.internal_fields do
    ref.options :status
  end
end

# split into groups of fields edited together
# form-view

# /referrals/new      # has all public fields
# /referrals          # define what's in the table? or put everything?
# /referrals/edit/12
# /referrals/edit/12/referrer # ?
# /referrals/edit/12/status

# What organisation do you work for? (if applicable)
#   Your full name
#   our Phone number
#   First Name
#   Last Name
#   Age range
#   Postcode
#   Full Address
#   Telephone number (the best one for the person being referred to be phoned on)
#   Reason for referral
#   Living arrangements
#   Would they want phone calls in English?
#   If they need a phone call in any language other than English, please detail below
#   Any other information that you would like a volunteer to know e.g any interests that you, things they like doing or they might like to talk about
#   Please confirm that...
#   Do you/they have any additional needs which a caller may need to be aware of?
#   Is this a referral from the Elmore?
#   DOB (if known)
