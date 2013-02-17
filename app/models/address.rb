class Address < ActiveRecord::Base
  attr_accessible :user, :city, :country, :full_name, :line_1, :line_2,
                  :phone_number, :postcode

  belongs_to :user

  validates :full_name, presence: true
end
