class PeopleController < ApplicationController
  before_action :set_person, only: %i[show new_role create_role events details edit update disambiguate]

  def show
    redirect_to events_person_path(@person)
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
              Caller.new(start_date: Date.today)
            when "callee"
              Callee.new(start_date: Date.today)
            when "pod_leader"
              PodLeader.new(start_date: Date.today)
            when "admin"
              Admin.new(start_date: Date.today)
            else
              Caller.new(start_date: Date.today)
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

  def edit; end

  def create
    role = person_params[:role]
    @person = Person.new(person_params.except(:role))

    if @person.save
      redirect_to "#{disambiguate_person_path(@person)}?role=#{role}", notice: "Person was successfully created."
    else
      render :new
    end
  end

  def disambiguate
    @similar_people = Person.take(4)
  end

  def update
    if @person.update(person_params)
      redirect_to @person, notice: "Person was successfully updated."
    else
      render :edit
    end
  end

  private

  def set_person
    @person = Person.with_roles.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:role, :title, :first_name, :last_name, :email, :phone)
  end

  def caller_params
    params.require(:caller).permit(:start_date, :person_id)
  end

  def callee_params
    params.require(:callee).permit(:start_date, :person_id)
  end

  def admin_params
    params.require(:admin).permit(:start_date, :person_id)
  end

  def pod_leader_params
    params.require(:pod_leader).permit(:start_date, :person_id)
  end
end
