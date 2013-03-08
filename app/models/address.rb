class Address < ActiveRecord::Base
  attr_accessible :user, :city, :country, :full_name, :line_1, :line_2,
                  :phone_number, :postcode, :info

  belongs_to :user, inverse_of: :addresses
  has_many   :orders
  has_many :reviews, dependent: :nullify

  with_options presence: true do |check|
    check.validates :full_name
    check.validates :city
    check.validates :country
    check.validates :line_1
    check.validates :phone_number
    check.validates :postcode, format:{
                      :with => %r{^\d{5}(-\d{4})?$},
                      :message => "should be 12345 or 12345-1234"}
  end
  #validates :user, presence: false
  #validates :line_2, allow_blank: true


  def info
    "
    #{full_name}<br/>
    #{line_1}<br/>
    #{line_2}<br/>
    #{country}<br/>
    #{city}<br/>
    #{postcode}<br/>
    #{phone_number}<br/>
    ".gsub(/^\s*<br\/>$/,'').html_safe
  end

end
