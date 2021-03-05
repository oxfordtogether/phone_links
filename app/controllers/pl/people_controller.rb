class Pl::PeopleController < Pl::PlController
  before_action :set_person, only: %i[show]

  def show
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

    @report_events = if @person.callee.present?
                       Report.where(match_id: @person.callee.match_ids)
                     elsif @person.caller.present?
                       Report.where(match_id: @person.caller.match_ids)
                     else
                       []
                     end

    @events = (@std_events + @match_events + @report_events + @role_events).sort_by(&:created_at).reverse
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
