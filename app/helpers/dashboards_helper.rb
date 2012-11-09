module DashboardsHelper
  
  def display_metrics(metric)
    metric ||= 0
    number_with_delimiter(metric, :delimiter => ".")
  end
  
  def show_date(date)
    return "Hoy" if date.nil? || date == Date.today
    l @date, :format => :short
  end
  
  def show_percent(value,total)
    result = value.to_f * 100 / total.to_f 
    #{}"#{number_with_precision(result, :locale => "es-CL", :precision => 1)} %"
    "PICO"
  end
  
end
