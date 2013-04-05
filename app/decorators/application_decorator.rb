class ApplicationDecorator < Draper::Decorator
  include Draper::LazyHelpers

  def stars_rating
    stars = (5 - (model.rating || 0) ) * -13 - 1
    h.content_tag :div, '', class: 'stars-rating',
      style: "background-position: #{stars}px 0;"
  end

  def self.collection_decorator_class
    PaginatingDecorator
  end
end
