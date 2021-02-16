class C::CController < ApplicationController
  layout "c/layouts/authorized"

  before_action :caller_only
end
