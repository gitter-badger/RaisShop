class RegistrationsController < Devise::RegistrationsController

  def edit
    @addresses = current_user.addresses
    super
  end
end
