class User < ActiveRecord::Base
  before_create :create_account

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :account_name
  # attr_accessible :title, :body
  validates_presence_of :account_name, :on => :create 
  validates_uniqueness_of  :email, :case_sensitive => false
  attr_accessor :account_name
  belongs_to :account

  private
    def create_account
      self.account = Account.find_by_name(self.account_name)
      self.account ||= Account.create!(:name => self.account_name)
    end

end
