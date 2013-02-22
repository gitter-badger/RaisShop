class Address < ActiveRecord::Base
  attr_accessible :user, :city, :country, :full_name, :line_1, :line_2,
                  :phone_number, :postcode, :info

  belongs_to :user, inverse_of: :addresses
  has_many   :orders

  #validates :user, presence: true
  validates :full_name, presence: true


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
