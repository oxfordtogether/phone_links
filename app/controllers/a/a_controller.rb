class A::AController < ApplicationController
  layout "a/layouts/authorized"

  before_action :admin_only
end
