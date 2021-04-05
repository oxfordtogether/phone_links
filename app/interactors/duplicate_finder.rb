class DuplicateFinder
  def self.find_duplicates(referral)
    existing_people = Person.all

    duplicates = existing_people.filter do |p|
      (p.last_name == referral.last_name && p.first_name[0] == referral.first_name[0])
    end

    duplicates[0..5]
  end
end
