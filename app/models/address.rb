class Address < ActiveRecord::Base
  attr_accessible :user, :city, :country, :full_name, :line_1, :line_2,
                  :phone_number, :postcode, :info

  belongs_to :user, inverse_of: :addresses
  has_many   :orders

  validates :user, presence: false
  validates :full_name, presence: true
  validates :city, presence: true
  validates :country, presence: true
  validates :line_1, presence: true
  validates :line_2, presence: false
  validates :phone_number, presence: true
  validates :postcode, presence: true, format:{
                    :with => %r{^\d{5}(-\d{4})?$},
                    :message => "should be 12345 or 12345-1234"}


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
