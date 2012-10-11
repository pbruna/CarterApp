class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  
  attr_accessor :account_name
  
  belongs_to :account
  after_create :set_account_owner
  before_create :set_password_token
  before_destroy :account_owner?
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable#, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  validates_presence_of :email
  validates_presence_of :account
  validates_presence_of :encrypted_password
  validates_uniqueness_of :email

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  
  field :name, :type => String
  field :phone, :type => String

  def account_id
    account.id
  end
  
  def account_name
    return account.name unless account.nil?
    @account_name
  end
  
  def owner?
    id == account.owner.id
  end
  
  def root?
    account.root?
  end

  private
  def set_account_owner
    account.owner_id = id if account.owner_id.nil?
    account.save
  end
  
  def set_password_token
    self.reset_password_token = User.reset_password_token
    self.reset_password_sent_at = Time.now
  end
  
  def account_owner?
    return true unless owner?
    errors.add(:account, "You cant delete an account owner")
    false
  end
   
end
