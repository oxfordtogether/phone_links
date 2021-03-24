class Pl::PeopleController < Pl::PlController
  def show
    @person = @fetcher.person(params[:id])
    @pod = @person.callee.present? ? @person.callee.pod : @person.caller.pod

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
end
