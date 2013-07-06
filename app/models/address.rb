class Address
  include Mongoid::Document

  field :line_1, type: String
  field :line_2, type: String
  field :city, type: String
  field :country, type: String
  field :postcode, type: String
  field :phone_number, type: String

  belongs_to :customer
  has_many   :orders

  accepts_nested_attributes_for :customer

  with_options presence: true do |check|
    check.validates :city
    check.validates :country
    check.validates :line_1
    check.validates :phone_number
    check.validates :postcode, format:{
                      :with => %r{\A\d{5}(-\d{4})?\z},
                      :message => "should be 12345 or 12345-1234"}
  end

  before_destroy :at_least_one_address

  def info_in_html
    "#{line_1}
    #{line_2}
    #{country}
    #{city}
    #{postcode}
    #{phone_number}".gsub(/\n\s*/,'<br/>').html_safe
  end


private

  def at_least_one_address
    if !customer.nil? && customer.addresses.count <= 1
      errors.add(:destroy, "You can't delete your only address")
    end
    errors[:destroy].blank?
  end

end
