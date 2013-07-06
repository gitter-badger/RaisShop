class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title,       type: String
  field :description, type: String
  field :image_url,   type: String
  field :price,       type: BigDecimal
  field :rating,      type: Integer
  slug  :title
  #field :_id, type: String, default: -> { title.to_s.parameterize }

  has_many :line_items
  #has_many :orders, through: :line_items
  has_many :reviews, order: 'created_at asc', dependent: :destroy

  belongs_to :category

  validates_presence_of :title, :description, :image_url, :price, :category

  before_destroy :ensure_not_referenced_by_any_line_item

  after_save :average_rating

  #pg_search_scope :search_by_title, against: :title,
    #using: {
            #trigram: {prefix: true},
            #dmetaphone: {
              #any_word: true,
              #dictionary: "english",
              #tsvector_columnt: 'tsv',
              #prefix: true}
           #}


  def self.title_search(query)
    #if query.present?
      #search_by_title(query)
    #else
      all
    #end
  end

  #self.per_page = 10

  def average_rating
    average = (self.reviews.avg(:rating) || 0).round
    update_attribute(:rating, average) unless average == self.rating
  end


private

  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      true
    else
      errors.add(:base, 'Line Items Present')
      false
    end
  end
end
