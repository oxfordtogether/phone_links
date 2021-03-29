class C::MatchesController < C::CController
  def show
    @match = @fetcher.match(params[:id])
    @caller = @match.caller
    @reports = @match.reports.sort_by(&:created_at).reverse
  end
end
