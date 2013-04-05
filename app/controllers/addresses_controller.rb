class AddressesController < ApplicationController
  before_filter :signed_in_only

  def new
    @address = current_user.addresses.build
  end

  def edit
    @address = current_user.addresses.find_by_id(params[:id])
    if @address.nil?
      redirect_to addresses_path, notice: "You can access only your own address"
    end
  end

  def create
    @address = current_user.addresses.build(params[:address])

    if @address.save
      redirect_to addresses_path, notice: 'Address was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @address = current_user.addresses.find(params[:id])

    if @address.update_attributes(params[:address])
      redirect_to addresses_path, notice: 'Address was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @address = current_user.addresses.find(params[:id])
    @address.destroy
    redirect_to addresses_path
  end
end
