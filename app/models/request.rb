class Request
  include Mongoid::Document
  
  field :request_id, :type => String
  field :queue_id, :type => String
  field :src_hostname
  field :account_id
  field :running, :type => Integer
  
  def self.last_for_account(account_id, qty = 25)
    begin
      where(account_id: account_id).sort(:_id => -1).limit(qty).to_a
    rescue Exception => e
      []
    end
  end
  
  def self.search(account_id, params = {})
    # Clean any empty search field
    params.delete_if {|k,v| v.blank? }
    return [] if params.empty?
    params.merge!(account_id: account_id)
    begin
      where(params).to_a
    rescue Exception => e
      []
    end 
  end
  
  def status_name
    "En cola" if running?
    "Procesado"
  end
  
  def running?
    running == 1
  end
  
  def dst_email_address
    read_attribute(:dst_email_address) || []
  end
  
  def elapsed_time
    read_attribute(:delay)
  end
  
end