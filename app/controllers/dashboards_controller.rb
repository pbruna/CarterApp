class DashboardsController < ApplicationController

  def show
    @date = params[:date]
    if @date
      month = Date.parse(@date).month
    end
    account_id = current_account.sasl_login
    @metrics = MetricsDaily.find_for_dashboard(@date, account_id)
    @graph_data = MetricsDaily.data_for_monthly_graph(account_id, month)
  end
    
end
