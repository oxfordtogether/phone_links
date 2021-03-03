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
    @events = Event.most_recent_first
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

    @events += @match_events
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
      @person.create_events!
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
      @person.create_events!
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
      @person.create_events!
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
      @person.create_events!
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
      @person.create_events!
      SearchCacheRefresh.perform_async
      redirect_to experience_a_edit_person_path(@person), notice: "Profile was successfully updated."
    else
      render "edit/experience"
    end
  end

  def active
    render "a/people/edit/active"
  end

  def save_active
    active_params_hash = active_params.to_h

    # set added_to_waiting_list date based on on_waiting_list bool from form
    if active_params_hash.key?("caller_attributes")
      caller_attributes = active_params_hash["caller_attributes"]

      on_waiting_list = caller_attributes.delete("on_waiting_list")

      caller_attributes = if on_waiting_list == "true"
                            caller_attributes.merge({ added_to_waiting_list: Date.today })
                          else
                            caller_attributes.merge({ added_to_waiting_list: nil })
                          end

      active_params_hash["caller_attributes"] = caller_attributes
    elsif active_params_hash.key?("callee_attributes")
      callee_attributes = active_params_hash["callee_attributes"]

      on_waiting_list = callee_attributes.delete("on_waiting_list")

      callee_attributes = if on_waiting_list == "true"
                            callee_attributes.merge({ added_to_waiting_list: Date.today })
                          else
                            callee_attributes.merge({ added_to_waiting_list: nil })
                          end

      active_params_hash["callee_attributes"] = callee_attributes
    end

    @person.assign_attributes(active_params_hash)

    if @person.save
      @person.create_events!
      SearchCacheRefresh.perform_async
      redirect_to active_a_edit_person_path(@person), notice: "Profile was successfully updated."
    else
      render "edit/active"
    end
  end

  def pod_membership
    render "a/people/edit/pod_membership"
  end

  def save_pod_membership
    @person.assign_attributes(pod_membership_params)

    if @person.save
      @person.create_events!
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
      @person.create_events!
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

  def active_params
    params.require(:person).permit(:id, callee_attributes: %w[id active on_waiting_list], caller_attributes: %w[id active on_waiting_list], admin_attributes: %w[id active], pod_leader_attributes: %w[id active])
  end

  def pod_membership_params
    params.require(:person).permit(:id, callee_attributes: %w[id pod_id], caller_attributes: %w[id pod_id])
  end

  def emergency_contacts_params
    params.require(:person).permit(:id, callee_attributes: [:id, { emergency_contacts_attributes: %w[name contact_details relationship] }])
  end
end
