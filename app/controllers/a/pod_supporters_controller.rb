class A::PodSupportersController < A::AController
  def destroy
    @pod_supporter = PodSupporter.find(params[:id])
    @pod_supporter.delete

    redirect_to pod_supporters_a_pod_path(@pod_supporter.pod), notice: "Pod supporter was removed."
  end
end
