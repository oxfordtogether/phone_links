class C::PagesController < C::CController
  def home
    @current_user = current_user
    @current_caller = current_caller

    matches = current_caller.match_ids
    @reports = Report.where(match_id: matches)
    @matches = current_caller.matches
  end
end
