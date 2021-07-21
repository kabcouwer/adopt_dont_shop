class AdminsController < ActionController::Base

  def shelters_index
    @shelters = Shelter.order_by_reverse_alphabetical
  end

  def application_show
    @application = Application.find(params[:id])
    @pets = @application.pets
  end

  def application_approved
    @application = Application.find(params[:application])
    @pet = Pet.find(params[:pet])
    @pet_application = PetApplication.find_by(pet_id: @pet.id, application_id: @application.id)

    @pet_application.status = "Approved"
    @pet_application.save
    redirect_to "/admin/applications/#{@application.id}"
  end
end
