class Request
  include Mongoid::Document
  embeds_one :amavis_data, class_name: "AmavisData"
  embeds_many :messages
  belongs_to :account
  
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
  scope :dst_email_address, ->(address) { where(:dst_email_address.in => [/#{address}/i])}
  scope :src_email_address, ->(address) { where(:src_email_address => /#{address}/i) }
  
  def self.last_for_account(account_id, qty = DEFAULT_PAGE_LIMIT)
    begin
      where(account_id: account_id).sort(:_id => -1).limit(qty).to_a
    rescue Exception => e
      []
    end
  end
  
  def self.search(account_id, params = {}, limit = DEFAULT_PAGE_LIMIT, page = 0)
    search_criteria_builder(account_id, params, limit, page).to_a
  end
  
  def self.search_resume(account_id, params = {}, limit = 0, page = 0)
    # make the hash default to 0 so that += will work correctly
    hash = Hash.new{|h,k| h[k]=Hash.new(0) }
    criteria = search_criteria_builder(account_id, params, limit, page)
    result = criteria.only(:running, :amavis_data, :status).to_a
    resume = result.map {|request| {:status => request.status_name, :css_class => request.status_css} }
    resume.each do |el|
      hash[el[:status]][:count] += 1
      hash[el[:status]][:css_class] = el[:css_class] if hash[el[:status]][:css_class] == 0
    end
    hash
  end
  
  def self.search_criteria_builder(account_id, params = {}, limit = DEFAULT_PAGE_LIMIT, page = 0)
    # Clean any empty search field
    params.delete_if {|field, value| value.blank? }
    return [] if params.empty?
    base_criteria = where(account_id: account_id)
    params.each do |field, value|
      criteria = Request.send(field, value.rstrip) # Remove ending whitespaces for v
      base_criteria.merge! criteria if criteria
    end
    begin
      base_criteria.skip(page * limit).limit(limit)
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
    return "Bloqueado" if status == "reject"
    return "Encolado" if running?
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
    when "encolado" then "warning"
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
  
  def sasl_username
    read_attribute(:sasl_username) || nil
  end
  
  def elapsed_time
    read_attribute(:delay)
  end
  
  def status
    read_attribute(:status) || ""
  end
  
end