class ReferralStatusBadgeComponent < ViewComponent::Base
  def initialize(referral)
    @referral = referral
  end

  attr_reader :referral
end
