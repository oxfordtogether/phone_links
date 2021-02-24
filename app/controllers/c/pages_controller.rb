class C::PagesController < C::CController
  def home
    @current_user = current_user
    # @reports_count = Callee.with_matches.all.filter(&:waiting?).count
    matches = current_caller.match_ids
    @reports = Report.where(match_id: matches)
    @matches = current_caller.matches
  end

  def support; end
end
