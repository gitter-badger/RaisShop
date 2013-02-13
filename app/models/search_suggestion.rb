class SearchSuggestion < ActiveRecord::Base
  attr_accessible :popularity, :term

  belongs_to :product

  def self.terms_for(prefix)
    Rails.cache.fetch(["search-terms", prefix]) do
      suggestions = where("term ILIKE ?", "#{prefix}%")
      suggestions.includes(:product).order("popularity desc").limit(10).map do |item|
        product = item.product
        {id: product.to_param, title: product.title, image_url: product.image_url,
         price: product.price, rating: product.rating}
      end
    end
  end

  def self.index_products
    Product.find_each do |product|
      index_term(product.title, product.id)
      product.title.split.each { |t| index_term(t, product.id) }
    end
  end

  def self.index_term(term, product_id)
    where(term: term).first_or_initialize.tap do |suggestion|
      suggestion.product_id = product_id
      suggestion.increment! :popularity
    end
  end
end
