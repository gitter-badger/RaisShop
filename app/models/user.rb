class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  attr_accessible :full_name, :email, :password, :password_confirmation,
    :remember_me

  has_many :addresses, dependent: :destroy
  has_many :orders, through: :addresses
  has_many :reviews, dependent: :nullify

  validates_presence_of :email, unless: :guest?
  validates_presence_of :full_name
  validates :email, uniqueness: true,
    format: { with: Devise.email_regexp }, allow_blank: true, if: :email_changed?
  validates :password, presence: true, confirmation: true,
            length: { within: Devise.password_length }, unless: :guest?

  def can_write_review?(product)
    product.reviews.where(user_id: id).count == 0
  end

  def self.new_guest(options={})
    user = new(options)
    user.guest = true
    user
  end
end
