class Message
  include Mongoid::Document
  embedded_in :request
  
  def self.delivery_stats
    hash = {sent: 0, deferred: 0, bounced: 0}
    self.each do |message|
      hash[message.status.to_sym] += 1
    end
    hash
  end
  
end