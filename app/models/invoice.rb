class Invoice
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  #attr_accessible :account_id, :active, :plan_id, :total, :date, :due_date
  belongs_to :account
  
  field :active, :type => Boolean
  field :plan_id, :type => Integer
  field :due_date, :type => Date
  field :close_date, :type => Date
  field :total, :type => Integer
  
  def status_name
    date_today = Date.today
    if date_today > due_date && active?
      "Vencida"
    elsif date_today < due_date && active?
      "Activa"
    elsif !active?
      "Pagada"
    end
  end
  
end
