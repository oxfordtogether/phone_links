class Pl::PlController < ApplicationController
  layout "pl/layouts/authorized"

  before_action :set_fetcher

  private

  def set_fetcher
    @fetcher = if @is_admin
                 admin = Admin.find(session[:admin_id])
                 Pl::PodLeaderDataFetcher.new(admin: admin)
               else
                 # if no pod_leader_id in session this will throw RecordNotFound
                 pod_leader = PodLeader.find(session[:pod_leader_id])
                 Pl::PodLeaderDataFetcher.new(pod_leader: pod_leader)
               end
  end
end
