class NewMatchReflex < ApplicationReflex
  def filter_callers_and_callees(pod_id = nil)
    @pod_id = pod_id
  end
end
