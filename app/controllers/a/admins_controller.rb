class A::AdminsController < A::AController
  def index
    @admins = Admin.all
  end
end
