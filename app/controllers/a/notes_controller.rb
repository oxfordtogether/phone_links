class A::NotesController < A::AController
  def new
    callee = Callee.find(params[:id])
    @note = Note.new(created_by: current_user, callee: callee)
    @person = callee.person
  end

  def create
    @note = Note.new(note_params)

    if @note.save
      redirect_to a_person_path(@note.callee.person), notice: "Note was successfully created."
    else
      @person = callee.person
      render :new
    end
  end

  private

  def note_params
    params.require(:note).permit(:created_by_id, :callee_id, :content)
  end
end
