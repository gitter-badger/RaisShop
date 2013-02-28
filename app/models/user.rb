class User < ActiveRecord::Base

  #default_scope includes(:addresses)

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation,
    :remember_me, :addresses_attributes, :current_address_id

  has_many :addresses, dependent: :destroy, inverse_of: :user
  has_many :reviews, through: :addresses
  accepts_nested_attributes_for :addresses

  after_save :set_default_address

  validates :addresses, presence: true
  validates :password, confirmation: true

  def current_address
    addresses.find(current_address_id)
  end

  def full_name
    current_address.full_name
  end

  def available_address_ids
    addresses.map(&:id)
  end

private

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
