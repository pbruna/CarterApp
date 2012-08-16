class User < ActiveRecord::Base
  before_save :set_trial_plan, :on => :create
  before_save :set_sasl_login, :on => :create
  before_save :set_sasl_password, :on => :create
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable #, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  PLANS = {
    :trial => {:id => 1},
    :lite => {:id => 2},
    :professional => {:id => 3},
    :enterprise => {:id => 4}
  }
  SASL_PASSWORD_LENGTH=10
  
  
  def payment_day
    self.created_at.day
  end

  private
  def set_trial_plan
    self.plan_id = PLANS[:trial][:id]
  end
  
  def set_sasl_login
    self.sasl_login = self.email.gsub(/@/,"_")
  end
  
  def set_sasl_password
    self.sasl_password_view = generate_random_password()
    self.sasl_password = Digest::MD5.hexdigest(self.sasl_password_view)
  end
  
  def generate_random_password
    (("A".."Z").to_a + ("a".."z").to_a + (0..9).to_a).sample(10).join("")
  end

end
