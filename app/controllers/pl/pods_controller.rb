class Pl::PodsController < Pl::PlController
  def show
    @pod = @fetcher.pod(params[:id])

    @report_count = @fetcher.all_reports(params[:id]).count
  end

  def support
    @pod = @fetcher.pod(params[:id])

    render "pl/pods/support"
  end
end
