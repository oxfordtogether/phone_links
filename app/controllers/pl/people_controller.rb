class Pl::PeopleController < Pl::PlController
  before_action :set_person, only: %i[show]

  def show
    @events = @person.events_to_display
  end

  private

  def set_person
    @person = Person.find(params[:id])

    redirect_to "/invalid_permissions_for_page" unless current_pod_leader.pod.callers.include?(@person.caller)
  end

  def person_params
    params.require(:person).permit
  end
end
