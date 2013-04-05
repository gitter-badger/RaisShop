module ApplicationHelper
  def full_title(page_title)
    site_name = "RaisShop"
    if page_title.blank?
      "#{site_name} - The Place To Buy Stuff"
    else
      "#{page_title} - #{site_name}"
    end
  end

  def set_page_title(page_title)
    content_for(:title) { page_title }
  end
end
