class A::PodLeadersController < A::AController
  def index
    @pod_leaders = PodLeader.all
  end
end
