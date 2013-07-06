class Category
  include Mongoid::Document
  include Mongoid::Slug
  #include Mongoid::Ancestry
  #attr_accessible :parent_id, :name

  field :name, type: String
  slug :name

  has_many :products
  #has_ancestry

  #def to_param
    #"#{id}-#{name}".parameterize
  #end
end
