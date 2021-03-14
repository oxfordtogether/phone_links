class Pl::PagesController < Pl::PlController
  skip_before_action :access_only_with_pod?

  def home
    @current_user = current_user
    @current_pod_leader = current_pod_leader
    @pod = @current_pod_leader.pod

    if @pod.present?
      @report_count = Report.all.filter { |r| r.legacy_pod_id == @pod.id || @pod.matches.include?(r.match) }.count
    else
      @report_count = nil
    end
  end

  def support
    render "pl/pages/support"
  end
end
