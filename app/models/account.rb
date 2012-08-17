# encoding: UTF-8
class Account < ActiveRecord::Base
  before_save :set_trial_plan_and_active, :on => :create
  before_save :set_sasl_login, :on => :create
  before_save :set_sasl_password, :on => :create
  attr_accessible :active, :address, :country, :id, :name, :plan_id, :sasl_login
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  has_many :users

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
    def set_trial_plan_and_active
      self.plan_id = PLANS[:trial][:id]
      self.active = true
    end

    def set_sasl_login
      self.sasl_login = remove_foreign_chars(self.name.downcase.gsub(/\s+/,""))
    end

    def set_sasl_password
      self.sasl_password_view = generate_random_password()
      self.sasl_password = Digest::MD5.hexdigest(self.sasl_password_view)
    end

    def generate_random_password
      (("A".."Z").to_a + ("a".."z").to_a + (0..9).to_a).sample(10).join("")
    end
    
    #We remove accents and ñ for the sasl_login
    def remove_foreign_chars(string)
      ActiveSupport::Multibyte::Chars.new(string).mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/,'').to_s
    end

end
