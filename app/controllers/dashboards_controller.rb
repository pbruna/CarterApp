class DashboardsController < ApplicationController

  def show
    @date = params[:date].nil? ? Date.today : Date.parse(params[:date])
    account_id = current_account.id
    @metrics = MetricsDaily.find_for_dashboard(@date, account_id)
    @graph_data = MetricsDaily.data_for_monthly_graph(account_id, @date.month) unless @metrics.nil?
    
    # If the user logins and there is no data for the current date
    # we redirect to the last date with data
    if params[:date].nil? && @metrics.nil?
      last_date = MetricsDaily.last_date_with_data(account_id)
      redirect_to dashboards_path(:date => last_date) unless last_date.nil?
    end
  end

end
