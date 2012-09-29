class AmavisData
  include Mongoid::Document
  embedded_in :request
  
  def find_by_status(status)
    where(status: status)
  end
  
end