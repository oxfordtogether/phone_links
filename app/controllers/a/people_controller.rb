class A::PeopleController < A::AController
  before_action :set_person, only: %i[show events details actions create_role
                                      personal_details save_personal_details
                                      contact_details save_contact_details
                                      flag save_flag
                                      referral_details save_referral_details
                                      experience save_experience
                                      active save_active
                                      pod_membership save_pod_membership
                                      emergency_contacts save_emergency_contacts]

  def show
    redirect_to events_a_person_path(@person)
  end

  def events
    @std_events = Event.most_recent_first
                       .where(person_id: @person.id)
                       .all
                       .filter(&:active?)

    @match_events = if @person.callee.present?
                      MatchStatusChange.where(match_id: @person.callee.match_ids)
                    elsif @person.caller.present?
                      MatchStatusChange.where(match_id: @person.caller.match_ids)
                    else
                      []
                    end

    @role_events = @person.callee.present? ? RoleStatusChange.where(callee_id: @person.callee.id) : []
    @role_events += @person.caller.present? ? RoleStatusChange.where(caller_id: @person.caller.id) : []
    @role_events += @person.pod_leader.present? ? RoleStatusChange.where(pod_leader_id: @person.pod_leader.id) : []
    @role_events += @person.admin.present? ? RoleStatusChange.where(admin_id: @person.admin.id) : []

    @report_events = if @person.callee.present?
                       Report.where(match_id: @person.callee.match_ids)
                     elsif @person.caller.present?
                       Report.where(match_id: @person.caller.match_ids)
                     else
                       []
                     end

    @events = (@std_events + @match_events + @report_events + @role_events).sort_by(&:created_at).reverse
  end

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

    @person.send("build_#{@role}")

    if @person.save
      SearchCacheRefresh.perform_async
      redirect_to personal_details_a_edit_person_path(@person), notice: "Profile was successfully created."
    else
      @redirect_on_cancel || a_path

      @status ||= :start
      @results ||= []

      render :new
    end
  end

  def actions; end

  def create_role
    role = create_role_params[:role]
    @person.send("build_#{role}")

    if @person.save
      SearchCacheRefresh.perform_async
      redirect_to events_a_person_path(@person), notice: "Role was successfully added."
    else
      render :actions
    end
  end

  def personal_details
    render "a/people/edit/personal_details"
  end

  def save_personal_details
    @person.assign_attributes(personal_details_params)

    if @person.save
      SearchCacheRefresh.perform_async
      redirect_to personal_details_a_edit_person_path(@person), notice: "Profile was successfully updated."
    else
      render "edit/personal_details"
    end
  end

  def contact_details
    render "a/people/edit/contact_details"
  end

  def save_contact_details
    @person.assign_attributes(contact_details_params)

    if @person.save
      SearchCacheRefresh.perform_async
      redirect_to contact_details_a_edit_person_path(@person), notice: "Profile was successfully updated."
    else
      render "edit/contact_details"
    end
  end

  def flag
    @current_user = current_user
    render "a/people/edit/flag"
  end

  def save_flag
    old_flag = @person.flag_in_progress?
    old_flag_note = @person.flag_note

    @person.assign_attributes(flag_params)

    if @person.flag_in_progress? != old_flag
      @person.flag_updated_by_id = current_user.id
      @person.flag_updated_at = Time.now
    end
    # TO DO what if note is updated by flag isn't??

    if @person.save
      SearchCacheRefresh.perform_async
      redirect_to a_person_path(@person), notice: "Profile was successfully updated."
    else
      render "edit/flag" # shouldn't ever happen???
    end
  end

  def referral_details
    render "a/people/edit/referral_details"
  end

  def save_referral_details
    @person.assign_attributes(referral_details_params)

    if @person.save
      SearchCacheRefresh.perform_async
      redirect_to referral_details_a_edit_person_path(@person), notice: "Profile was successfully updated."
    else
      render "edit/referral_details"
    end
  end

  def experience
    render "a/people/edit/experience"
  end

  def save_experience
    @person.assign_attributes(experience_params)

    if @person.save
      SearchCacheRefresh.perform_async
      redirect_to experience_a_edit_person_path(@person), notice: "Profile was successfully updated."
    else
      render "edit/experience"
    end
  end

  def pod_membership
    render "a/people/edit/pod_membership"
  end

  def save_pod_membership
    @person.assign_attributes(pod_membership_params)

    if @person.save
      SearchCacheRefresh.perform_async
      redirect_to pod_membership_a_edit_person_path(@person), notice: "Profile was successfully updated."
    else
      render "edit/pod_membership"
    end
  end

  def emergency_contacts
    render "a/people/edit/emergency_contacts"
  end

  def save_emergency_contacts
    @person.assign_attributes(emergency_contacts_params)

    if @person.save
      SearchCacheRefresh.perform_async
      redirect_to emergency_contacts_a_edit_person_path(@person), notice: "Profile was successfully updated."
    else
      render "edit/emergency_contacts"
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

  def personal_details_params
    params.require(:person).permit(:id, :title, :first_name, :last_name, :age_bracket)
  end

  def contact_details_params
    params.require(:person).permit(:id, :address_line_1, :address_line_2, :address_town, :address_postcode, :email, :phone)
  end

  def flag_params
    params.require(:person).permit(:id, :flag_in_progress, :flag_updated_at, :flag_updated_by_id, :flag_note)
  end

  def referral_details_params
    params.require(:person).permit(:id, callee_attributes: %w[id reason_for_referral living_arrangements other_information call_frequency additional_needs])
  end

  def experience_params
    params.require(:person).permit(:id, caller_attributes: %w[id experience])
  end

  def pod_membership_params
    params.require(:person).permit(:id, callee_attributes: %w[id pod_id], caller_attributes: %w[id pod_id])
  end

  def emergency_contacts_params
    params.require(:person).permit(:id, callee_attributes: [:id, { emergency_contacts_attributes: %w[name contact_details relationship] }])
  end
end
