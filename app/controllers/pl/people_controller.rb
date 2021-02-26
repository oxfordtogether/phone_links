class Pl::PeopleController < Pl::PlController
  before_action :set_person, only: %i[show]

  def show
    @events = Event.most_recent_first
                   .where(person_id: @person.id)
                   .all
                   .filter(&:active?)
  end

  private

  def set_person
    @person = Person.find(params[:id])

    # TO DO
    # redirect_to "/invalid_permissions_for_page" if @person.caller.pod != current_pod_leader.pod || @person.callee.pod !=
  end

  def person_params
    params.require(:person).permit
  end
end
