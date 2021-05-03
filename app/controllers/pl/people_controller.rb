class Pl::PeopleController < Pl::PlController
  before_action :set_person, only: %i[show edit update]

  def show
    @events = []

    if params["notes"] != "false"
      @events += Note.where(person_id: @person.id)
    end

    if params["reports"] != "false"
      @events += if @person.callee.present?
        Report.where(match_id: @person.callee.match_ids)
      elsif @person.caller.present?
        Report.where(match_id: @person.caller.match_ids)
      else
        []
      end
    end

    if params["status_changes"] != "false"
      @events += if @person.callee.present?
                        MatchStatusChange.where(match_id: @person.callee.match_ids)
                      elsif @person.caller.present?
                        MatchStatusChange.where(match_id: @person.caller.match_ids)
                      else
                        []
                      end

      @events += @person.callee.present? ? RoleStatusChange.where(callee_id: @person.callee.id) : []
      @events += @person.caller.present? ? RoleStatusChange.where(caller_id: @person.caller.id) : []
    end

    @events = @events.sort_by(&:created_at).reverse
  end

  def edit
    if @person.caller
      redirect_to edit_pl_person_path(@person, :contact_details) unless params[:page]
    elsif @person.callee
      redirect_to edit_pl_person_path(@person, :referral_details) unless params[:page]
    end
  end

  def update
    if @person.update(details_params)
      SearchCacheRefresh.perform_async
      redirect_to edit_pl_person_path(@person, params[:page]), notice: "Profile was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_person
    @person = @fetcher.person(params[:id])
    @pod = @person.callee.present? ? @person.callee.pod : @person.caller.pod
  end

  def details_params
    params.require(:person)
          .permit(:id, :address_line_1, :address_line_2, :address_town, :address_postcode, :phone,
                  caller_attributes: %w[id check_in_frequency pod_whatsapp_membership has_capacity capacity_notes]
          )
  end
end
