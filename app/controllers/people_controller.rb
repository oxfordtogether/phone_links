class PeopleController < ApplicationController
  before_action :set_person, only: %i[show new_role create_role events details edit update disambiguate]

  def show
    if @person.callee.present? || @person.caller.present?
      redirect_to details_person_path(@person)
    else
      redirect_to events_person_path(@person)
    end
  end

  def events; end

  def details; end

  def new_role
    all_role_options = [{ label: "Caller", value: "caller", disabled: false, selected: false },
                        { label: "Callee", value: "callee", disabled: false, selected: true },
                        { label: "Pod leader", value: "pod_leader", disabled: false, selected: false },
                        { label: "Admin", value: "admin", disabled: false, selected: false }]

    # @role_options = all_role_options.filter { |r| .. }
    # filter out invalid options
    @role_options = all_role_options

    @role = case params["role"]
            when "caller"
              Caller.new
            when "callee"
              Callee.new(y)
            when "pod_leader"
              PodLeader.new
            when "admin"
              Admin.new
            else
              Caller.new
            end
  end

  def create_role
    @role = if params.key?("caller")
              Caller.new(caller_params)
            elsif params.key?("callee")
              Callee.new(callee_params)
            elsif params.key?("pod_leader")
              PodLeader.new(pod_leader_params)
            elsif params.key?("admin")
              Admin.new(admin_params)
              # add an else, raise error
            end

    if @role.save
      redirect_to @person, notice: "Role was successfully created."
    else
      render :new_role
    end
  end

  def new
    @person = Person.new
    @role = params[:role]

    @status ||= :start
    @results ||= []
  end

  def validate
    @role = person_params[:role]
    @person = Person.new(person_params.except(:role))

    if @person.valid?
      @similar_people = SearchCache.get_similar_people(@person, limit: 5)

      render :disambiguate
    else
      @status ||= :start
      @results ||= []

      # after rendering :new, search starts hanging
      render :new
    end
  end

  def create
    @role = person_params[:role]
    @person = Person.new(person_params.except(:role))

    if @person.save
      redirect_to "/people/#{@person.id}/#{@role}/new", notice: "Profile was successfully created."
    else
      # should not reach this point as data is already validated
      render :new
    end
  end

  def edit; end

  def update
    if @person.update(person_params)
      redirect_to @person, notice: "Profile was successfully updated."
    else
      render :edit
    end
  end

  private

  def set_person
    @person = Person.with_roles.find(params[:id])
  end

  def person_params
    params.require(:person).permit(
      :role, :title, :first_name, :last_name, :email, :phone,
      callee_attributes: %i[id active reason_for_referral living_situation other_information additional_needs],
      caller_attributes: %i[id active experience],
      admin_attributes: %i[id active],
      pod_leader_attributes: %i[id active]
    )
  end
end
