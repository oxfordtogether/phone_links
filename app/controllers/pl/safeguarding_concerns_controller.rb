class Pl::SafeguardingConcernsController < Pl::PlController
  before_action :set_safeguarding_concern, only: %i[show]

  def new
    @safeguarding_concern = SafeguardingConcern.new
    @pod = @fetcher.pod(params[:id])
    @callee_people_records = @fetcher.callees(@pod.id).map(&:person)
  end

  def create
    @safeguarding_concern = SafeguardingConcern.new(create_safeguarding_concern_params.merge({ "status": :unread, "status_changed_at": DateTime.now, "created_by_id": Current.person_id }))
    @pod = @fetcher.pod(params[:id])

    if @safeguarding_concern.save
      SafeguardingEmailWorker.perform_async(@safeguarding_concern.id)
      redirect_to pl_safeguarding_concerns_path(@pod), notice: "Safeguarding form successfully submitted."
    else
      @callee_people_records = @fetcher.callees(@pod.id).map(&:person)
      render :new
    end
  end

  def show; end

  def index
    @pod = @fetcher.pod(params[:id])
    @safeguarding_concerns = @fetcher.safeguarding_concerns(@pod.id)
  end

  private

  def set_safeguarding_concern
    @safeguarding_concern = @fetcher.safeguarding_concern(params[:id])
    @pod = @safeguarding_concern.person.callee.pod
    @status_changes = @safeguarding_concern.safeguarding_concern_status_changes.sort_by(&:datetime).reverse
  end

  def create_safeguarding_concern_params
    params.require(:safeguarding_concern).permit(:person_id, :concerns)
  end
end
