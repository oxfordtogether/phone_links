class C::PagesController < C::CController
  def home
    @matches = @fetcher.matches
    @reports = @fetcher.reports
  end
end
