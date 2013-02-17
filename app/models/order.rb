class Order < ActiveRecord::Base
  attr_accessible  :name, :pay_type

  belongs_to :user
end
