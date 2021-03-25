class A::ReferralsController < A::AController
  before_action :set_referral, only: [:show, :update, :new_callee]

  def index
    @referrals = Referral.all
  end

  def show
    @referral.notes = nil
    @duplicates = DuplicateFinder.find_duplicates(@referral)
  end

  def update
    if @referral.update(referral_params.merge({ status_changed_at: DateTime.now }))
      redirect_to a_referral_path(@referral), notice: "Referral was successfully updated"
    else
      render :show
    end
  end

  def new_callee
    callee = @referral.new_callee

    if callee.save
      redirect_to a_person_path(callee.person), notice: "Callee was successfully created."
    else
      render :show, notice: "Error creating callee."
    end
  end

  private

  def set_referral
    @referral = Referral.find(params[:id])
    @status_changes = @referral.referral_status_changes.sort_by(&:datetime).reverse
  end

  def referral_params
    params.require(:referral).permit(:status, :notes)
  end
end
