class Pl::PagesController < Pl::PlController
  skip_before_action :access_only_with_pod?

  def home
    @current_pod_leader = current_pod_leader
    @pod = @current_pod_leader.pod

    @report_count = (Report.where(legacy_pod_id: @pod.id).count + Report.where(legacy_pod_id: nil).where(match_id: @pod.matches.map(&:id)).count if @pod.present?)
  end

  def support
    render "pl/pages/support"
  end
end
