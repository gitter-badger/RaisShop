class Product < ActiveRecord::Base
  attr_accessible :title, :description, :image_url, :price, :category_id
  has_many :line_items
  has_many :reviews, dependent: :destroy, order: "reviews.created_at ASC"
  belongs_to :category
  before_destroy :ensure_not_referenced_by_any_line_item
  validates_presence_of :title, :description, :image_url, :price, :category
  validates :title, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug

  def to_param
    slug
  end

  include PgSearch

  pg_search_scope :search_by_title, against: :title,
    using: {
            trigram: {prefix: true},
            dmetaphone: {
              any_word: true,
              dictionary: "english",
              tsvector_columnt: 'tsv',
              prefix: true}
           }

  def generate_slug
    self.slug ||= title.parameterize
  end

  def self.title_search(query)
    if query.present?
      search_by_title(query)
    else
      scoped
    end
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
