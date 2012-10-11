class Account
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  
  SASL_PASSWORD_LENGTH=10

  field :owner_id, type: Moped::BSON::ObjectId
  field :name, type: String
  field :active, type: Boolean
  field :plan_id, type: Integer
  field :address, type: String
  field :country, type: String
  field :address2, type: String
  field :city, type: String
  field :rut, type: String
  field :root, type: Boolean

  #attr_accessible :active, :address, :country, :id, :name, :plan_id, :sasl_login, :city, :rut
  
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validate :plan_id_number, :on => :update
  #validate :presence_of_owner, :on => :create

  has_many :users, :dependent => :destroy
  has_many :requests,  :dependent => :destroy
  accepts_nested_attributes_for :users, :allow_destroy => true
  #belongs_to :owner, :class_name => "User"
  has_many :invoices, :dependent => :destroy
  
  before_create :set_trial_plan_and_active
  #after_save :set_owner, :if => :owner_nil?
  before_update :create_invoice_if_trial, :if => Proc.new {|account| account.plan_id_changed?}
  before_destroy { |account| return false if account.root? }

  PLANS = {
    :trial => {:id => 1, :days => 30, :name => "Trial", :price => 0},
    :lite => {:id => 2, :name => "Lite", :price => 45000},
    :professional => {:id => 3, :name => "Pyme", :price => 75000},
    :enterprise => {:id => 4, :name => "Empresarial", :price => 100000}
  }
  
  def self.any_root_account?
    where(:root => true).to_a.size > 0
  end

  def owner
    User.find(owner_id)
  end
  
  def owner_nil?
    owner_id.nil?
  end
  
  def request_qty
    requests.count
  end

  def reverse_invoices
    invoices.reverse
  end
  
  def plans_for_select
    if trial?
      PLANS.each_key.to_a.map {|k| {:value => PLANS[k][:id], :label => PLANS[k][:name].titleize}}
    else
      # We remove the trial plan if the account is not trial
      PLANS.each_key.to_a.map {|k| {:value => PLANS[k][:id], :label => PLANS[k][:name].titleize}}[1..3]
    end
  end

  def plan_key_from_id(id)
    PLANS.select{|key, hash| hash[:id] == id}.keys.first
  end

  def plan_name_from_id(id)
    PLANS[plan_key_from_id(id)][:name]
  end

  def active?
    return false if has_debt?
    return false if trial? && !trial_current?
    true
  end

  def has_invoices?
    invoices.size > 0
  end

  def has_debt?
    false
  end

  def trial?
    plan_id == PLANS[:trial][:id]
  end

  def trial_current?
    trial_days_left > 0
  end

  def trial_end_date
    (created_at + (3600*24*PLANS[:trial][:days])).to_date
  end

  def trial_days_left
    ( trial_end_date - Date.today).to_i
  end

  def first_login?
    owner.sign_in_count == 1
  end

  def payment_day
    self.created_at.day
  end

  def create_invoice_for_trial
    plan_key = plan_key_from_id(plan_id)
    price = PLANS[plan_key][:price]
    due_date = trial_end_date + 30
    invoices << Invoice.create!({:active => true, :plan_id => plan_id, :total => price, :date => Date.today.to_time, :due_date => due_date})
  end

  private
    def set_owner
      update_attribute(:owner_id, self.users.first.id)
    end
    
    def presence_of_owner
      errors.add(:owner_id, "Must have an owner") if owner_id.nil?
    end
  
    def delete_data
      users.destroy_all
      invoices.destroy_all
    end
  
    def plan_id_number
      return if plan_id > 0 && plan_id <= PLANS.size
      errors.add(:plan_id, "No es un Plan valido")
    end

    def set_trial_plan_and_active
      self.plan_id = PLANS[:trial][:id]
      self.active = true
    end

    def create_invoice_if_trial
      return if plan_id_was != 1
      self.create_invoice_for_trial
    end

end
