class Pl::PeopleController < Pl::PlController
  before_action :set_person, only: %i[show]

  def show
    @events = @person.events_to_display
  end

  private

  def set_person
    @person = Person.find(params[:id])

    redirect_to "/invalid_permissions_for_page" unless people_in_pod.include?(@person)
  end

  def person_params
    params.require(:person).permit
  end

  def people_in_pod
    current_pod_leader.pod.callers.map(&:person) + current_pod_leader.pod.callees.map(&:person)
  end
end
