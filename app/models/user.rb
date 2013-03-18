class User < ActiveRecord::Base

  #default_scope includes(:addresses)

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  attr_accessible :full_name, :email, :password, :password_confirmation,
    :remember_me, :addresses_attributes, :current_address_id

  has_many :addresses, dependent: :destroy, inverse_of: :user
  has_many :orders, through: :addresses
  has_many :reviews
  accepts_nested_attributes_for :addresses, allow_destroy: true

  before_validation :check_if_guest

  validates_presence_of :email, unless: :guest?
  validate  :full_name, presence: true
  validates :email, uniqueness: true,
    format: { with: Devise.email_regexp }, allow_blank: true, if: :email_changed?
  validates :password, presence: true, confirmation: true,
            length: { within: Devise.password_length }, unless: :guest?

  def current_address
    addresses.find(current_address_id)
  end

  def available_address_ids
    addresses.map(&:id)
  end

private

  def check_if_guest
    if password.blank?
      self.guest = true
    else
      self.guest = false
    end
  end

  def set_current_address(id)
    update_attribute :current_address_id, id if addresses.one? do |address|
      address.id == id
    end
  end

  def set_default_address
    if current_address_id.nil?
      set_current_address(addresses.first.id)
    end
  end
end
