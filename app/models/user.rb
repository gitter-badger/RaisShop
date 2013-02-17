class User < ActiveRecord::Base

  #default_scope includes(:addresses)

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password,
                  :password_confirmation, :remember_me, :addresses_attributes
  has_many :reviews
  has_many :addresses
  accepts_nested_attributes_for :addresses

  after_save :set_default_address

  validates :addresses, presence: true

  def full_name
    addresses.find(current_address_id).full_name
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
