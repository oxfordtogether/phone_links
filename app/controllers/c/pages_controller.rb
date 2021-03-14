class C::PagesController < C::CController
  def home
    @current_user = current_user
    @current_caller = current_caller

    @matches = current_caller.active_matches + current_caller.paused_matches + current_caller.winding_down_matches
    @reports = Report.where(match_id: current_caller.match_ids)
  end
end
