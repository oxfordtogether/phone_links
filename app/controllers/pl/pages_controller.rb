class Pl::PagesController < Pl::PlController
  def home
    @current_user = current_user
  end
end
