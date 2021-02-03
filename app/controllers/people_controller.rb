class PeopleController < ApplicationController
  before_action :set_person, only: %i[show new_role create_role events details edit update]

  def show
    redirect_to events_person_path(@person)
  end

  def events; end

  def details; end

  def new_role
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
    @role = case params["role"]
            when "Caller"
              Caller.new(caller_params)
            when "Callee"
              Callee.new(callee_params)
            when "PodLeader"
              PodLeader.new(pod_leader_params)
            when "Admin"
              Admin.new(admin_params)
            else
              Caller.new(caller_params)
            end

    if @role.save
      redirect_to @person, notice: "Role was successfully created."
    else
      render :new_role
    end
  end

  def new
    @person = Person.new
  end

  def edit; end

  def create
    @person = Person.new(person_params)

    if @person.save
      redirect_to @person, notice: "Person was successfully created."
    else
      render :new
    end
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
    params.require(:person).permit(:title, :first_name, :last_name, :email, :phone)
  end

  def caller_params
    params.require(:caller).permit(:start_date, :role)
  end

  def callee_params
    params.require(:callee).permit(:start_date, :role)
  end

  def admin_params
    params.require(:admin).permit(:start_date, :role)
  end

  def pod_leader_params
    params.require(:pod_leader).permit(:start_date, :role)
  end
end
