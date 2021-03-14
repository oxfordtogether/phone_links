class C::CalleesController < C::CController
  before_action :set_callee_and_match, only: %i[show]

  def show
    @current_caller = current_caller
    @reports = Report.where(match_id: @match.id).sort_by(&:created_at).reverse
  end

  private

  def set_callee_and_match
    @callee = Callee.find(params[:id])
    @match = Match.where(callee: @callee, caller: current_caller).first

    raise unless %i[active paused winding_down].include?(@match.status)
  rescue StandardError
    redirect_to "/invalid_permissions_for_page"
  end
end
