class Pl::NotesController < Pl::PlController
  before_action :set_note, only: %i[edit update destroy]

  def new
    @person = Person.find(params[:id])

    return redirect_to "/invalid_permissions_for_page" unless people_in_pod.include?(@person)

    @note = Note.new(created_by: current_pod_leader.person, person: @person)
  end

  def create
    return redirect_to "/invalid_permissions_for_page" unless people_in_pod.map(&:id).include?(note_params[:person_id].to_i) && current_pod_leader.person.id == note_params[:created_by_id].to_i

    @note = Note.new(note_params)

    if @note.save
      @note.create_events!

      redirect_to pl_person_path(current_pod_leader, @note.person), notice: "Note was successfully created."
    else
      @person = @note.person
      render :new
    end
  end

  def edit
    redirect_to "/invalid_permissions_for_page" if @note.created_by != current_pod_leader.person

    @person = @note.person
  end

  def update
    redirect_to "/invalid_permissions_for_page" if @note.created_by != current_pod_leader.person

    if @note.update(note_params)
      @note.create_events!
      redirect_to pl_person_path(current_pod_leader, @note.person), notice: "Note was successfully updated."
    else
      @person = @note.person
      render :edit
    end
  end

  def destroy
    redirect_to "/invalid_permissions_for_page" if @note.created_by != current_pod_leader.person

    @note.update(deleted_at: Time.now)
    @note.create_events!

    redirect_to pl_person_path(current_pod_leader, @note.person), notice: "Note was successfully deleted."
  end

  private

  def set_note
    @note = Note.find(params[:id])
    redirect_to "/invalid_permissions_for_page" unless people_in_pod.include?(@note.person)
  end

  def note_params
    params.require(:note).permit(:created_by_id, :person_id, :content)
  end

  def people_in_pod
    current_pod_leader.pod.callers.map(&:person) + current_pod_leader.pod.callees.map(&:person)
  end
end
