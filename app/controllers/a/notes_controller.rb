class A::NotesController < A::AController
  before_action :set_note, only: %i[edit update destroy]

  def new
    @person = Person.find(params[:id])
    @note = Note.new(created_by: @current_user, person: @person)
  end

  def create
    @note = Note.new(note_params)

    if @note.save
      @note.create_events!

      redirect_to a_person_path(@note.person), notice: "Note was successfully created."
    else
      @person = @note.person
      render :new
    end
  end

  def edit
    @person = @note.person
  end

  def update
    if @note.update(note_params)
      @note.create_events!

      redirect_to a_person_path(@note.person), notice: "Note was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @note.update(deleted_at: Time.now)
    @note.create_events!

    redirect_to a_person_path(@note.person), notice: "Note was successfully deleted."
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:created_by_id, :person_id, :content)
  end
end
