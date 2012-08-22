class User < ActiveRecord::Base
  before_create :create_account
  after_create  :set_account_owner

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :account_name, :name, :phone
  # attr_accessible :title, :body
  validates_presence_of :account_name, :on => :create 
  validates_uniqueness_of  :email, :case_sensitive => false
  validate :account_name_uniqueness, :on => :create
  attr_accessor :account_name
  belongs_to :account

  def account_id
    account.id
  end

  private
    def create_account
      self.account ||= Account.create!(:name => self.account_name)
    end
    
    def account_name_uniqueness
      errors.add(:account_name, "El nombre de la Empresa ya Existe") unless Account.find_by_name(self.account_name).nil?
    end
    
    def set_account_owner
      account = self.account
      account.owner_id = self.id
      account.save
    end

end
