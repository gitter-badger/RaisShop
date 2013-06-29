class Category < ActiveRecord::Base
  #attr_accessible :parent_id, :name
  has_many :products
  has_ancestry

  def to_param
    "#{id}-#{name}".parameterize
  end
end
