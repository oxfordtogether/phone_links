class Pl::PlController < ApplicationController
  before_action :pod_leader_only
end
