class C::CallersController < C::CController
  def show
    @caller = @fetcher.caller(params[:id])

    @matches = @fetcher.matches(@caller.id)
    @reports = @fetcher.all_reports(@caller.id)
  end
end
