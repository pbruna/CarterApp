class DashboardsController < ApplicationController

  def show
    @date = params[:date]
    account_id = current_account.sasl_login
    @metrics = MetricsDaily.find_for_dashboard(@date, account_id)
    @graph_data = MetricsDaily.data_for_monthly_graph(account_id)
  end
    
end
