class A::PodsController < A::AController
  before_action :set_pod, only: %i[show edit update pod_supporters save_pod_supporters]

  def index
    @pods = Pod.all
  end

  def show
    redirect_to matches_a_pod_path(@pod)
  end

  def matches
    @pod = Pod.with_matches.find(params[:id])
    @matches = @pod.matches.filter { |m| !m.provisional_cancelled }
  end

  def callers
    @pod = Pod.with_matches.find(params[:id])
    @callers = @pod.callers
  end

  def callees
    @pod = Pod.with_matches.find(params[:id])
    @callees = @pod.callees
  end

  def new
    @pod = Pod.new
    @safeguarding_leads = (Admin.all.map(&:person) + PodLeader.all.map(&:person)).uniq
  end

  def edit
    @safeguarding_leads = (Admin.all.map(&:person) + PodLeader.all.map(&:person)).uniq
  end

  def create
    @pod = Pod.new(pod_params)

    if @pod.save
      redirect_to a_pod_path(@pod), notice: "Pod was successfully created."
    else
      @safeguarding_leads = (Admin.all.map(&:person) + PodLeader.all.map(&:person)).uniq
      render :new
    end
  end

  def update
    if @pod.update(pod_params)
      redirect_to a_pod_path(@pod), notice: "Pod was successfully updated."
    else
      @safeguarding_leads = (Admin.all.map(&:person) + PodLeader.all.map(&:person)).uniq
      render :edit
    end
  end

  def pod_supporters
  end

  def save_pod_supporters
    puts pod_supporter_params
    @pod.assign_attributes(pod_supporter_params)
    if @pod.save!
      redirect_to pod_supporters_a_pod_path(@pod), notice: "Pod supporter was created."
    else
      render :pod_supporters
    end
  end

  private

  def set_pod
    @pod = Pod.find(params[:id])
  end

  def pod_params
    params.require(:pod).permit(:name, :pod_leader_id, :theme, :safeguarding_lead_id)
  end

  def pod_supporter_params
    params.require(:pod).permit(:id, pod_supporters_attributes: %i[pod_id supporter_id])
  end
end
