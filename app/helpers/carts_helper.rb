module CartsHelper
  def checkout_params
    if @cart.empty?
      {method: :get, class: 'btn disabled', disabled: true}
    else
      {method: :get, class: 'btn', disabled: false}
    end

  end
end
