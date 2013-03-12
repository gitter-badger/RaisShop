class Address < ActiveRecord::Base
  attr_accessible :user, :city, :country, :line_1, :line_2,
                  :phone_number, :postcode, :info, :user_attributes

  belongs_to :user
  has_many   :orders
  has_many :reviews, dependent: :nullify
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
  #validates :user, presence: false
  #validates :line_2, allow_blank: true


  def info
    "
    #{line_1}<br/>
    #{line_2}<br/>
    #{country}<br/>
    #{city}<br/>
    #{postcode}<br/>
    #{phone_number}<br/>
    ".gsub(/^\s*<br\/>$/,'').html_safe
  end

end
