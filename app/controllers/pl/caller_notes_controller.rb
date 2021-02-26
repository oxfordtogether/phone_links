class Pl::CallerNotesController < Pl::PlController
  before_action :set_note, only: %i[edit update destroy]

  def new
    @caller = Caller.find(params[:id])
    @person = @caller.person
    @note = Note.new(created_by: current_user, person: @person)
    @cancel = pl_caller_path(@current_pod_leader, @caller)
    @new_url = notes_pl_caller_path(@current_pod_leader, @caller)

    render "pl/callers/new_note"
  end

  def create
    @note = Note.new(note_params)

    if @note.save
      @note.create_events!

      redirect_to pl_caller_path(current_pod_leader, @note.person.caller), notice: "Note was successfully created."
    else
      @person = @note.person
      @caller = @person.caller
      @cancel = pl_caller_path(@current_pod_leader, @caller)
      @new_url = notes_pl_caller_path(@current_pod_leader, @caller)
      render "pl/callers/new_note"
    end
  end

  def edit
    @person = @note.person
    @caller = @person.caller
    @cancel = pl_caller_path(@current_pod_leader, @caller)

    render "pl/callers/new_note"
  end

  def update
    if @note.update(note_params)
      @note.create_events!
      redirect_to pl_caller_path(current_pod_leader, @note.person.caller), notice: "Note was successfully updated."
    else
      @person = @note.person
      @caller = @person.caller
      @cancel = pl_caller_path(@current_pod_leader, @note)
      render :edit
    end
  end

  def destroy
    @note.update(deleted_at: Time.now)
    @note.create_events!

    redirect_to pl_caller_path(current_pod_leader, @note.person.caller), notice: "Note was successfully deleted."
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:created_by_id, :person_id, :content)
  end
end
