class A::PeopleController < A::AController
  before_action :set_person, only: %i[show events details actions create_role
                                      edit update
                                      save_invite]

  def show
    redirect_to events_a_person_path(@person)
  end

  def events
    @events = []

    @events += Note.where(person_id: @person.id) if params["notes"] != "false"

    if params["reports"] != "false"
      @events += if @person.callee.present?
                   Report.where(match_id: @person.callee.match_ids)
                 elsif @person.caller.present?
                   Report.where(match_id: @person.caller.match_ids)
                 else
                   []
                 end
    end

    if params["status_changes"] != "false"
      @events += if @person.callee.present?
                   MatchStatusChange.where(match_id: @person.callee.match_ids)
                 elsif @person.caller.present?
                   MatchStatusChange.where(match_id: @person.caller.match_ids)
                 else
                   []
                 end

      @events += @person.callee.present? ? RoleStatusChange.where(callee_id: @person.callee.id) : []
      @events += @person.caller.present? ? RoleStatusChange.where(caller_id: @person.caller.id) : []
      @events += @person.pod_leader.present? ? RoleStatusChange.where(pod_leader_id: @person.pod_leader.id) : []
      @events += @person.admin.present? ? RoleStatusChange.where(admin_id: @person.admin.id) : []

      @events += PersonFlagChange.where(person_id: @person.id)
    end

    @events = @events.sort_by(&:created_at).reverse
  end

  def new
    @person = Person.new
    @role = params[:role]

    @status ||= :start
    @results ||= []
  end

  def create
    @role = person_params[:role]
    @person = Person.new(person_params.except(:role))

    if %w[caller callee].include?(@role)
      @person.send("build_#{@role}", { status: "waiting_list", status_change_datetime: DateTime.now })
    else
      @person.send("build_#{@role}", { status: "active", status_change_datetime: DateTime.now })
    end

    if @person.save
      SearchCacheRefresh.perform_async
      redirect_to edit_a_person_path(@person), notice: "Profile was successfully created."
    else
      @status ||= :start
      @results ||= []

      render :new
    end
  end

  def actions; end

  def create_role
    role = create_role_params[:role]
    @person.send("build_#{role}", { status: "active", status_change_datetime: DateTime.now })

    if @person.save
      SearchCacheRefresh.perform_async
      redirect_to events_a_person_path(@person), notice: "Role was successfully added."
    else
      render :actions
    end
  end

  def edit
    @person&.flag_change_notes = nil

    redirect_to edit_a_person_path(@person, :personal_details) unless params[:page]
  end

  def update
    if @person.update(details_params)
      SearchCacheRefresh.perform_async
      redirect_to edit_a_person_path(@person, params[:page]), notice: "Profile was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def save_invite
    InviteEmailWorker.perform_async(@person.id)
    if @person.update(invite_email_sent_at: DateTime.now)
      redirect_back(fallback_location: root_path, notice: "Email sent!")
    else
      redirect_back(fallback_location: root_path, notice: "Email sent!")
    end
  end

  private

  def set_person
    @person = Person.with_roles.find(params[:id])
  end

  def person_params
    params.require(:person).permit(
      :role, :first_name, :last_name, :phone
    )
  end

  def create_role_params
    params.require(:person).permit(
      :id, :role
    )
  end

  def details_params
    params.require(:person)
          .permit(:id, :title, :first_name, :last_name, :age_bracket, :opas_id,
                  :address_line_1, :address_line_2, :address_town, :address_postcode, :email, :phone,
                  :flag_in_progress, :flag_change_notes,
                  callee_attributes: [:id, :reason_for_referral, :living_arrangements, :other_information, :call_frequency, :additional_needs, :languages_notes, :pod_id, { emergency_contacts_attributes: %w[name contact_details relationship] }],
                  caller_attributes: %w[id experience languages_notes check_in_frequency pod_id])
  end
end
