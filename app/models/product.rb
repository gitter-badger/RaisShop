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


  def generate_slug
    self.slug ||= title.parameterize
  end
  #include Tire::Model::Search
  #include Tire::Model::Callbacks

  #settings :number_of_shards => 1,
    #:number_of_replicas => 1, :analysis => {
      #:filter => {
        #:url_ngram  => {
          #"type"     => "nGram",
          #"max_gram" => 5,
          #"min_gram" => 3 }
      #},
      #:analyzer => {
        #:url_analyzer => {
          #"tokenizer"    => "lowercase",
          #"filter"       => ["stop", "url_ngram"],
          #"type"         => "custom" }
      #}
    #} do
      #mapping do
        #indexes :title, boost: 10
        #indexes :description
        #indexes :image_url, index:'no'
        #indexes :price, index: 'no'
      #end
    #end

    #def self.search(params)
      #tire.search(page: params[:page], per_page: 5) do 
        #query { string params[:query], default_operator: "AND" } if params[:query].present?
      #end
    #end
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
