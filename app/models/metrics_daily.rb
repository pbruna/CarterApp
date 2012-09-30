class MetricsDaily
  
  include Mongoid::Document
  store_in collection: "metrics_daily"

  field :account_id
  field :request_qty, type: Integer
  field :date
  field :request_bytes, type: Integer
  field :sent_qty, type: Integer
  field :sent_failed_qty, type: Integer

  index({account_id: 1, date: 1})

  def self.find_for_dashboard(date, account_id)
    date ||= Date.today
    begin
      find_by(account_id: account_id, date: date.to_s)
    rescue Exception => e
      nil
    end
  end
  
  def self.last_date_with_data(account_id)
    where(account_id: account_id).last.date
  end

  def self.data_for_monthly_graph(account = "", month )
    month ||= Time.now.month
    ary = Array.new
    month_date = Time.now.months_ago(Time.now.month - month)
    bson_start_time = time_to_bson(month_date.beginning_of_month)
    bson_end_time = time_to_bson(month_date.end_of_month)
    result = where(:account_id => account).gte(:_id => bson_start_time)
             .lte(:_id => bson_end_time).only(:sent_qty, :sent_failed_qty, :date, :_id, :blocked_qty)
    result.each do |r|
      ary << {date: Date.parse(r.date), sent_qty: r.sent_qty, sent_failed_qty: r.sent_failed_qty, blocked_qty: r.blocked_qty }
    end
    ary
  end

  def dst_emails_count
    dst_emails.size
  end

  def src_emails_count
    src_emails.size
  end
  
  def blocked_qty
    read_attribute(:blocked_qty) || 0
  end

  def top_dst_emails(limit = 10)
    dst_emails.sort_by {|x| -x["count"]}.slice(0..(limit - 1))
  end

  def top_src_emails(limit = 10)
    src_emails.sort_by {|x| -x["count"]}.slice(0..(limit - 1))
  end

  private
    def sort_on_db(document_array, limit = 10)
      js = "ary = db.metrics_daily.findOne({_id:ObjectId('#{self._id}')}).#{document_array}.sort(function(a,b){return(b.count - a.count)}); return ary.slice(0,#{limit})"
      collection.database.command("$eval" => js, "nolock" => true)["retval"]
    end

    def self.time_to_bson(time = Time.now)
      Moped::BSON::ObjectId.from_time(time)
    end

end
