class C::MatchesController < C::CController
  def show
    @match = @fetcher.match(params[:id])
    @reports = @fetcher.reports_for_match(@match).sort_by(&:created_at).reverse
  end
end
