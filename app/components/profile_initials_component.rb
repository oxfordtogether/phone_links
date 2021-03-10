class ProfileInitialsComponent < ViewComponent::Base
  def initialize(initials:)
    @initials = initials
    @scheme = scheme
  end

  def scheme
    char_to_number = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("").zip((0..25).to_a).to_h

    (char_to_number[@initials[0]] * char_to_number[@initials[0]]) % 5
  end
end
