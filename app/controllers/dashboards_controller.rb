class DashboardsController < ApplicationController

  def show
    if params[:date]
      @date = Date.parse(params[:date])
    else
      @date = Date.today
    end
    month = @date.month
    account_id = current_account.sasl_login
    @metrics = MetricsDaily.find_for_dashboard(@date, account_id)
    @graph_data = MetricsDaily.data_for_monthly_graph(account_id, month)
  end

end
