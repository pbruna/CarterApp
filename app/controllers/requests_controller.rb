class RequestsController < ApplicationController
  before_filter :set_account

  def show
    account_id = @account.id
    @request = Request.where(account_id: account_id).find(params[:id])
    @delivery_stats = @request.messages.delivery_stats if @request.messages.size > 10
  end

  def index
    account_id = @account.id
    if params[:search].nil?
      @requests = Request.last_for_account(account_id)
    elsif search_blank?(params[:search])
      params.delete(:search)
      redirect_to requests_path(:managed_account => params[:managed_account])
    else
      @requests = Request.search(account_id, params[:search])
      @search_resume = Request.search_resume(account_id, params[:search]) if @requests.size > 10
    end

  end

  private
    def search_blank?(search_hash)
      search_hash.values.all? {|v| v.blank?}
    end
    
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
