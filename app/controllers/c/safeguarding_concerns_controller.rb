class C::SafeguardingConcernsController < C::CController
  def new
    @safeguarding_concern = SafeguardingConcern.new
    @callee_people_records = @fetcher.matches.map(&:callee).map(&:person)
  end

  def create
    @safeguarding_concern = SafeguardingConcern.new(create_safeguarding_concern_params.merge({ "status": :unread, "status_changed_at": DateTime.now, "created_by_id": Current.person_id }))

    if @safeguarding_concern.save
      SafeguardingEmailWorker.perform_async(@safeguarding_concern.id)
      redirect_to c_path(@current_caller), notice: "Safeguarding form successfully submitted."
    else
      @callee_people_records = @fetcher.matches.map(&:callee).map(&:person)
      render :new
    end
  end

  private

  def create_safeguarding_concern_params
    params.require(:safeguarding_concern).permit(:person_id, :concerns)
  end
end
