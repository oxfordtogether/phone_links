class A::EmergencyContactsController < A::AController
  before_action :set_emergency_contact, only: %i[update destroy]

  def update
    @emergency_contact.update(emergency_contact_params)

    if @emergency_contact.save
      redirect_to edit_a_person_path(@emergency_contact.callee.person, :emergency_contacts), notice: "Emergency contact was successfully updated."
    else
      @person = @emergency_contact.callee.person
      render "a/people/edit/emergency_contacts"
    end
  end

  def destroy
    @emergency_contact.delete

    redirect_to edit_a_person_path(@emergency_contact.callee.person, :emergency_contacts), notice: "Emergency contact was successfully deleted."
  end

  private

  def set_emergency_contact
    @emergency_contact = EmergencyContact.find(params[:id])
  end

  def emergency_contact_params
    params.require(:emergency_contact).permit(
      :name, :contact_details, :relationship
    )
  end
end
