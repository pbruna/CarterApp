class Request
  include Mongoid::Document
  embeds_one :amavis_data, class_name: "AmavisData"
  embeds_many :messages
  
  DEFAULT_PAGE_LIMIT = 50
  
  field :request_id, :type => String
  field :queue_id, :type => String
  field :src_hostname
  field :account_id
  field :running, :type => Integer
  
  index "dst_email_address" => 1
  index "src_email_address" => 1
  index "created_at" => 1
  index "account_id" => 1
  index "message_id" => 1
  
  scope :start_date, ->(date) { where(:created_at.gte => Time.parse(date).beginning_of_day.utc) }
  scope :end_date, ->(date) { where(:created_at.lte => Time.parse(date).end_of_day.utc) }
  scope :dst_email_address, ->(address) { where(:dst_email_address.in => [address])}
  scope :src_email_address, ->(address) { where(:src_email_address => address)}
  
  def self.last_for_account(account_id, qty = DEFAULT_PAGE_LIMIT)
    begin
      where(account_id: account_id).sort(:_id => -1).limit(qty).to_a
    rescue Exception => e
      []
    end
  end
  
  def self.search(account_id, params = {}, limit = DEFAULT_PAGE_LIMIT, page = 0)
    # Clean any empty search field
    params.delete_if {|k,v| v.blank? }
    return [] if params.empty?
    base_criteria = where(account_id: account_id)
    params.each do |k,v|
      criteria = Request.send(k, v.rstrip) # Remove ending whitespaces for v
      base_criteria.merge! criteria if criteria
    end
    begin
      base_criteria.skip(page * limit).limit(limit).to_a
    rescue Exception => e
      []
    end 
  end
  
  def amavis_checked?
    !amavis_data.nil?
  end
  
  def amavis_status
    amavis_data.amavis_status
  end
  
  def amavis_result
    amavis_data.amavis_result
  end
  
  # If you change this method you must change
  # the next one too: they are coupled!! :(
  def status_name
    return amavis_result if blocked_by_amavis?
    return "En cola" if running?
    "Procesado"
  end
  
  def blocked_by_amavis?
    return amavis_status.downcase != "passed" if amavis_checked?
    false
  end
  
  # TODO: See how we can decouple this from the above
  def status_css
    case status_name.downcase
    when "procesado" then "success"
    when "en cola" then "warning"
    else "important"
    end
  end
  
  def running?
    running > ( 1 - [request_id].flatten.size )
  end
  
  def dst_email_address
    read_attribute(:dst_email_address) || []
  end
  
  def src_email_address
    read_attribute(:src_email_address) || ""
  end
  
  # PASAR TODOS ESTOS a METHOD MISSING
  def closed_at
    read_attribute(:closed_at) || nil
  end
  
  def size
    read_attribute(:size) || 0
  end
  
  def elapsed_time
    read_attribute(:delay)
  end
  
end