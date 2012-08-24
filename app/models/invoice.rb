class Invoice < ActiveRecord::Base
  attr_accessible :account_id, :active, :plan_id, :total, :date, :due_date
  belongs_to :account
  
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
