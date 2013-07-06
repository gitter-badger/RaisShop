class Customer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, :type => String, :default => ""
  field :full_name, :type => String

  #attr_accessible :full_name, :email

  has_many :addresses, dependent: :destroy
  has_many :orders#, through: :addresses

  validates_presence_of :full_name
  validates :email, uniqueness: true,
    format: { with: Devise.email_regexp }, allow_blank: true, if: :email_changed?

  def guest?
    true
  end
end
