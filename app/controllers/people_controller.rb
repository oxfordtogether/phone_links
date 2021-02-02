class PeopleController < ApplicationController
  before_action :set_person, only: %i[show events details edit update]

  def show
    redirect_to events_person_path(@person)
  end

  def events; end

  def details; end

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
end
