class ProductsDecorator < PaginatingDecorator

  def header(search_input)
    ("Search results for \"#{search_input}\"" if search_input) || "All products"
  end

  def per_page_select_options(per_page)
    default = object.per_page
    options = h.options_for_select([5, 10, 20, 50, 100], per_page || default)
    h.select_tag "per_page", options
  end

  def submit_filtering
    h.submit_tag "Filter", class: 'btn'
  end

  def checkbox_for_endless_page(endless)
    h.label_tag("endless_page", "Endless page", class: 'checkbox') do
      h.check_box_tag("endless_page", true, endless == 'true') +
      "Endless page"
    end
  end
end
