class RequestsController < ApplicationController

  def show
    account_id = current_account.sasl_login
    @request = Request.where(account_id: account_id).find(params[:id])
    @delivery_stats = @request.messages.delivery_stats if @request.messages.size > 10
  end

  def index
    account_id = current_account.sasl_login
    if params[:search].nil?
      @requests = Request.last_for_account(account_id)
    elsif search_blank?(params[:search])
      params.delete(:search)
      redirect_to requests_path
    else
      @requests = Request.search(account_id, params[:search])
      @search_resume = Request.search_resume(account_id, params[:search]) if @requests.size > 10
    end

  end

  private
    def search_blank?(search_hash)
      search_hash.values.all? {|v| v.blank?}
    end

end
