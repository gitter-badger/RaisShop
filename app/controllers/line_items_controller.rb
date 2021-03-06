class LineItemsController < ApplicationController

  def show
    @line_item = LineItem.find(params[:id])
  end

  def create
    @line_item = @cart.add_product(params[:product_id])

    respond_to do |format|
      format.html { redirect_to @cart }
      format.js
    end
  end

  def update
    @line_item = LineItem.find(params[:id])

    if @line_item.update(line_item_params)
      redirect_to @line_item, notice: 'Line item was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy

    redirect_to line_items_url
  end

  def line_item_params
    params.require(:line_item).permit(:cart_id, :product_id, :quantity)
  end
end
