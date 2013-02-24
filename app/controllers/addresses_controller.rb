class AddressesController < ApplicationController

  def index
    @addresses = current_user.addresses
  end

  def new
    @address = current_user.addresses.build
  end

  def edit
    @address = Address.find(params[:id])
  end

  def create
    if user_signed_in?
      @address = current_user.addresses.build(params[:address])
    else
      @address = Address.new(params[:address])
    end

    respond_to do |format|
      if @address.save
        format.html { redirect_to addresses_path, notice: 'Address was successfully created.' }
        format.json { render json: @address, status: :created, location: @address }
      else
        format.html { render action: "new", notice: 'lol' }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @address = Address.find(params[:id])

    respond_to do |format|
      if @address.update_attributes(params[:address])
        format.html { redirect_to addresses_path, notice: 'Address was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @address = Address.find(params[:id])
    @address.destroy
  end
end
