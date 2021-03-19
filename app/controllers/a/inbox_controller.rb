class A::InboxController < A::AController
  def index
    @flagged = Person.where(flag_in_progress: true)
  end
end
