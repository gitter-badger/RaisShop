class User < Customer

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  attr_accessible :password, :password_confirmation, :remember_me
  has_many :reviews, dependent: :nullify

  validates_presence_of :email
  validates :password, presence: true, confirmation: true,
            length: { within: Devise.password_length }

  def can_write_review?(product)
    product.reviews.where(user_id: id).count == 0
  end

  def guest?
    false
  end

end
