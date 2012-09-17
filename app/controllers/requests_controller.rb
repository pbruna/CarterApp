class RequestsController < ApplicationController

  def show
    account_id = current_account.sasl_login
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
    end

  end

  private
    def search_blank?(search_hash)
      search_hash.values.all? {|v| v.blank?}
    end

end
