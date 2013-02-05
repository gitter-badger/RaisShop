class SearchSuggestionRedis

  def self.terms_for(prefix)
    $redis.zrevrange "search-suggestions:#{prefix.downcase}", 0, 9
  end

  def self.index_products
    Product.find_each do |product|
      index_term(product.title)
      index_term(product.category.name)
      product.title.split.each { |t| index_term(t) }
    end
  end

  def self.index_term(term)
    1.upto(term.length-1) do |n|
      prefix = term[0, n]
      $redis.zincrby "search-suggestions:#{prefix.downcase}", 1, term.downcase
    end
  end
end
