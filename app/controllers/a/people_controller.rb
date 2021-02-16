class A::PeopleController < A::AController
  before_action :set_person, only: %i[show events details actions edit update]

  def show
    if @person.callee.present? || @person.caller.present?
      redirect_to details_a_person_path(@person)
    else
      redirect_to events_a_person_path(@person)
    end
  end

  def events; end

  def details; end

  def new
    @person = Person.new
    @role = params[:role]
    @redirect_on_cancel = params[:redirect_on_cancel] || a_path # TO DO: better default

    @status ||= :start
    @results ||= []
  end

  def create
    @redirect_on_cancel = person_params[:redirect_on_cancel]
    @role = person_params[:role]
    @person = Person.new(person_params.except(:role, :redirect_on_cancel))

    if @person.save
      SearchCacheRefresh.perform_async
      redirect_to "/a/people/#{@person.id}/#{@role}/new", notice: "Profile was successfully created."
    else
      @redirect_on_cancel || a_path

      @status ||= :start
      @results ||= []

      render :new
    end
  end

  def edit; end

  def update
    if @person.update(person_params)
      SearchCacheRefresh.perform_async
      redirect_to a_person_path(@person), notice: "Profile was successfully updated."
    else
      render :edit
    end
  end

  def actions; end

  private

  def set_person
    @person = Person.with_roles.find(params[:id])
  end

  def person_params
    params.require(:person).permit(
      :role, :title, :first_name, :last_name, :email, :phone,
      callee_attributes: %i[id pod_id active reason_for_referral living_arrangements other_information additional_needs],
      caller_attributes: %i[id pod_id active experience],
      admin_attributes: %i[id active],
      pod_leader_attributes: %i[id active]
    )
  end
end
