class Pl::NotesController < Pl::PlController
  before_action :set_note, only: %i[edit update destroy]

  def new
    @person = @fetcher.person(params[:id])
    @note = Note.new(created_by_id: Current.person_id, person: @person)
    @pod = @person&.callee&.pod || @person&.caller&.pod
  end

  def create
    return redirect_to "/invalid_permissions_for_page" if Current.person_id != note_params[:created_by_id].to_i

    @note = Note.new(note_params)

    if @note.save
      @note.create_events!

      redirect_to pl_person_path(@note.person), notice: "Note was successfully created."
    else
      @person = @note.person
      render :new
    end
  end

  def edit
    redirect_to "/invalid_permissions_for_page" if Current.person_id != @note.created_by

    @person = @note.person
  end

  def update
    redirect_to "/invalid_permissions_for_page" if Current.person_id != @note.created_by

    if @note.update(note_params)
      @note.create_events!
      redirect_to pl_person_path(@note.person), notice: "Note was successfully updated."
    else
      @person = @note.person
      render :edit
    end
  end

  def destroy
    redirect_to "/invalid_permissions_for_page" if Current.person_id != @note.created_by

    @note.update(deleted_at: Time.now)
    @note.create_events!

    redirect_to pl_person_path(@note.person), notice: "Note was successfully deleted."
  end

  private

  def set_note
    @note = @fetcher.note(params[:id])
  end

  def note_params
    params.require(:note).permit(:created_by_id, :person_id, :content)
  end
end
