class User < ActiveRecord::Base

  #default_scope includes(:addresses)

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation,
    :remember_me, :addresses_attributes, :current_address_id
  has_many :reviews, dependent: :nullify
  has_many :addresses, dependent: :destroy, inverse_of: :user
  accepts_nested_attributes_for :addresses, allow_destroy: true

  after_save :set_default_address

  validates :addresses, presence: true

  def full_name
    addresses.find(current_address_id).full_name
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
