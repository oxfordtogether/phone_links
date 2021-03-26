class ReferralsController < ApplicationController
  skip_before_action :logged_in_using_omniauth?
  layout 'unauthorized'

  def index
    redirect_to new_referral_path
  end

  def new
    @referral = Referral.new
  end

  def create
    @referral = Referral.new(referral_params.merge({ submitted_at: DateTime.now, status: "unread", status_changed_at: DateTime.now }))

    if @referral.save
      redirect_to new_referral_path, notice: "Referral was successfully submitted."
    else
      flash.now[:notice] = "Referral form didn't submit, please check for errors."
      render :new
    end
  end

  private

  def referral_params
    params.require(:referral)
          .permit(:referrer_type, :referrer_organisation, :referrer_full_name, :referrer_phone, :referrer_email,
                  :first_name, :last_name, :phone, :age_bracket, :date_of_birth,
                  :address_line_1, :address_line_2, :address_town, :address_postcode,
                  :reason_for_referral, :additional_needs, :other_information, :other_support,
                  :languages,
                  :emergency_contact_name, :emergency_contact_relationship, :emergency_contact_details,
                  :confirm_consent, :confirm_data_shared, :confirm_data_protection)
  end
end
