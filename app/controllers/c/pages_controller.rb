class C::PagesController < C::CController
  def home
    @current_user = current_user
  end
end
