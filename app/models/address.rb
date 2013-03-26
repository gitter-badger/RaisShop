class Address < ActiveRecord::Base
  attr_accessible :user, :city, :country, :line_1, :line_2,
                  :phone_number, :postcode, :info, :user_attributes

  belongs_to :user
  has_many   :orders
  accepts_nested_attributes_for :user

  with_options presence: true do |check|
    check.validates :city
    check.validates :country
    check.validates :line_1
    check.validates :phone_number
    check.validates :postcode, format:{
                      :with => %r{^\d{5}(-\d{4})?$},
                      :message => "should be 12345 or 12345-1234"}
  end

  def info_in_html
    "#{line_1}
    #{line_2}
    #{country}
    #{city}
    #{postcode}
    #{phone_number}".gsub(/\n\s*/,'<br/>').html_safe
  end

end
