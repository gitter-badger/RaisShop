class User < Customer

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  field :encrypted_password, :type => String, :default => ""

  validates_presence_of :encrypted_password

  ## Recoverable
  field :reset_password_token, :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count, :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at, :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip, :type => String

  ## Confirmable
  # field :confirmation_token, :type => String
  # field :confirmed_at, :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email, :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token, :type => String # Only if unlock strategy is :email or :both
  # field :locked_at, :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  # run 'rake db:mongoid:create_indexes' to create indexes
  index({ email: 1 }, { unique: true, background: true })

  field :admin, type: Boolean, default: false

  #attr_accessible :password, :password_confirmation, :remember_me
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
