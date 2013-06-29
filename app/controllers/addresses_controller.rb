class AddressesController < ApplicationController
  before_filter :signed_in_only

  def new
    @address = current_user.addresses.build
  end

  def edit
    @address = current_user.addresses.find_by(id: (params[:id]))
    if @address.nil?
      redirect_to edit_user_registration_path, notice: "You can access only your own address"
    end
  end

  def create
    @address = current_user.addresses.build(address_params)

    if @address.save
      redirect_to edit_user_registration_path, notice: 'Address was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @address = current_user.addresses.find(params[:id])

    if @address.update(address_params)
      redirect_to edit_user_registration_path, notice: 'Address was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @address = current_user.addresses.find(params[:id])
    unless @address.destroy
      flash[:error] = @address.errors[:destroy].join
    end
    redirect_to edit_user_registration_path
  end

private

  def address_params
    params.require(:address).permit(:city, :country, :line_1, :line_2, :phone_number,
                  :postcode, :info, :customer_id, :customer_attributes)
  end
end
