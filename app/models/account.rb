# encoding: UTF-8
class Account < ActiveRecord::Base
  before_create :set_trial_plan_and_active
  before_create :set_sasl_login
  before_create :set_sasl_password
  before_destroy {|record| User.destroy_all "account_id = #{record.id}"}
  attr_accessible :active, :address, :country, :id, :name, :plan_id, :sasl_login, :city, :rut
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_uniqueness_of :sasl_login, :case_sensitive => false
  validate :plan_id_number, :on => :update
  has_many :users

  PLANS = {
    :trial => {:id => 1, :days => 30, :name => "Trial"},
    :lite => {:id => 2, :name => "Lite"},
    :professional => {:id => 3, :name => "Pyme"},
    :enterprise => {:id => 4, :name => "Empresarial"}
  }

  SASL_PASSWORD_LENGTH=10

  def plans_for_select
    if trial?
      PLANS.each_key.to_a.map {|k| {:value => PLANS[k][:id], :label => PLANS[k][:name].titleize}}
    else
      # We remove the trial plan if the account is not trial
      PLANS.each_key.to_a.map {|k| {:value => PLANS[k][:id], :label => PLANS[k][:name].titleize}}[1..3]
    end
  end

  def trial?
    plan_id == PLANS[:trial][:id]
  end

  def trial_days_left
    ((created_at + (3600*24*PLANS[:trial][:days])).to_date - Date.today).to_i
  end

  def owner
    User.find(owner_id)
  end

  def first_login?
    owner.sign_in_count == 1
  end

  def payment_day
    self.created_at.day
  end

  private
    def plan_id_number
      return if plan_id > 0 && plan_id <= PLANS.size
      errors.add(:plan_id, "No es un Plan valido")
    end
    
    def set_trial_plan_and_active
      self.plan_id = PLANS[:trial][:id]
      self.active = true
    end

    def set_sasl_login
      self.sasl_login = remove_foreign_chars(self.name.downcase.gsub(/\s+/,""))
      # If the sasl_login is taken we added the Date, what are the ods?
      self.sasl_login << Date.today.to_s(:db).gsub(/-/,'') unless Account.find_by_sasl_login(self.sasl_login).nil?
      errors.add(:sasl_login, "Ya existe, debe ser unico") unless Account.find_by_sasl_login(self.sasl_login).nil?
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
