class C::MatchesController < C::CController
  def show
    @match = @fetcher.match(params[:id])
    @reports = @fetcher.reports_for_match(@match).sort_by(&:date_of_call).reverse
  end
end
