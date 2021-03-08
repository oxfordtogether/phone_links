class Pl::PagesController < Pl::PlController
  skip_before_action :access_only_with_pod?

  def home
    @current_user = current_user
    @current_pod_leader = current_pod_leader
    @pod = @current_pod_leader.pod

    @report_count = Report.all.filter { |r| r.legacy_pod_id == @pod.id || @pod.matches.include?(r.match) }.count
  end

  def support
    render "pages/support"
  end
end
