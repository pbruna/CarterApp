class AmavisData
  include Mongoid::Document
  embedded_in :request
  
  def find_by_status(status)
    where(status: status)
  end
  
  def quarantine_file
    read_attribute(:quarantine_file) || nil
  end
  
end