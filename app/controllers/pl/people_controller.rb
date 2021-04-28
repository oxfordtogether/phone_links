class Pl::PeopleController < Pl::PlController
  before_action :set_person, only: %i[show edit check_ins contact_details save_check_ins save_contact_details]

  def show
    @notes = Note.where(person_id: @person.id)

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

    @events = (@notes + @match_events + @report_events + @role_events).sort_by(&:created_at).reverse
  end

  def edit
    redirect_to contact_details_pl_edit_person_path(@person)
  end

  def check_ins; end

  def contact_details; end

  def save_check_ins
    if @person.update(check_ins_params)
      redirect_to pl_person_path(@person), notice: "Person was successfully updated."
    else
      render :check_ins
    end
  end

  def save_contact_details
    if @person.update(contact_details_params)
      redirect_to pl_person_path(@person), notice: "Person was successfully updated."
    else
      render :contact_details
    end
  end

  private

  def set_person
    @person = @fetcher.person(params[:id])
    @pod = @person.callee.present? ? @person.callee.pod : @person.caller.pod
  end

  def contact_details_params
    params.require(:person).permit(:id, :address_line_1, :address_line_2, :address_town, :address_postcode, :phone)
  end

  def check_ins_params
    params.require(:person).permit(:id, caller_attributes: %w[id check_in_frequency])
  end
end
