class A::PodsController < A::AController
  before_action :set_pod, only: %i[show edit update]

  def index
    @pods = Pod.all
  end

  def show
    redirect_to matches_a_pod_path(@pod)
  end

  def matches
    @pod = Pod.with_matches.find(params[:id])
  end

  def callers
    @pod = Pod.with_matches.find(params[:id])
    @callers = @pod.callers
  end

  def callees
    @pod = Pod.with_matches.find(params[:id])
    @callees = @pod.active_matches.map { |m| m.caller }
  end

  def new
    @pod = Pod.new
  end

  def edit; end

  def create
    @pod = Pod.new(pod_params)

    if @pod.save
      redirect_to a_pod_path(@pod), notice: "Pod was successfully created."
    else
      render :new
    end
  end

  def update
    if @pod.update(pod_params)
      redirect_to a_pod_path(@pod), notice: "Pod was successfully updated."
    else
      render :edit
    end
  end

  private

  def set_pod
    @pod = Pod.find(params[:id])
  end

  def pod_params
    params.require(:pod).permit(:name, :pod_leader_id, :theme)
  end
end
