class Pl::PlController < ApplicationController
  layout "pl/layouts/authorized"

  before_action :pod_leader_only
end
