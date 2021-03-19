class A::SafeguardingConcernsController < A::AController
  before_action :set_safeguarding_concern, only: %i[show update]

  def new
    @safeguarding_concern = SafeguardingConcern.new
  end

  def create
    @safeguarding_concern = SafeguardingConcern.new(create_safeguarding_concern_params.merge({ "status": :unread, "status_changed_at": DateTime.now, "created_by_id": Current.person_id }))

    if @safeguarding_concern.save
      redirect_to a_safeguarding_concerns_path, notice: "Safeguarding form successfully submitted."
    else
      render :new
    end
  end

  def show
    @safeguarding_concern.status_changed_notes = nil
  end

  def update
    if @safeguarding_concern.update(update_safeguarding_concern_params.merge({ status_changed_at: DateTime.now }))
      redirect_to a_safeguarding_concern_path(@safeguarding_concern), notice: "Safeguarding concern was successfully updated"
    else
      render :show
    end
  end

  def index
    @safeguarding_concerns = SafeguardingConcern.all
  end

  private

  def set_safeguarding_concern
    @safeguarding_concern = SafeguardingConcern.find(params[:id])
    @status_changes = @safeguarding_concern.safeguarding_concern_status_changes.sort_by(&:datetime).reverse
  end

  def update_safeguarding_concern_params
    params.require(:safeguarding_concern).permit(:status, :status_changed_notes)
  end

  def create_safeguarding_concern_params
    params.require(:safeguarding_concern).permit(:person_id, :concerns)
  end
end
