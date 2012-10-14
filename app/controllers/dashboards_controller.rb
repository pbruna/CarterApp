class DashboardsController < ApplicationController
  before_filter :set_account


  def show
    account_id = @account.id
    @date = params[:date].nil? ? Date.today : Date.parse(params[:date])
    @metrics = MetricsDaily.find_for_dashboard(@date, account_id)
    @graph_data = MetricsDaily.data_for_monthly_graph(account_id, @date.month) unless @metrics.nil?
    
    # If the user logins and there is no data for the current date
    # we redirect to the last date with data
    if params[:date].nil? && @metrics.nil?
      last_date = MetricsDaily.last_date_with_data(account_id)
      redirect_to dashboards_path(:date => last_date) unless last_date.nil?
    end
  end


  private
  def set_account
    return @account = current_account unless current_account.root?
    if params[:managed_account].blank? 
      @account = current_account
      params[:managed_account] = @account.id
    else
      @account = Account.find(params[:managed_account])
      params[:managed_account] = params[:managed_account]
    end
  end

end
