class Request
  include Mongoid::Document
  
  field :request_id, :type => String
  field :queue_id, :type => String
  field :src_hostname
  field :account_id
  field :running, :type => Integer
end