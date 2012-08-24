# encoding: utf-8

class AccountsController < ApplicationController
  skip_before_filter :block_inactive_accounts!
  before_filter :display_warning_if_account_inactive
  
  def show
    @user = User.find(current_user.id, :include => :account)
    @account = @user.account
  end
  
  def update_plan
    @user = User.find(current_user.id, :include => :account)
    @account = @user.account
    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html {redirect_to @account, :notice => "Plan cambiado correctamente"}
        format.json {head :no_content}
      else
        flash[:error] = "No fue posible guardar cambiar el Plan"
        format.html {render action: "show"}
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @user = User.find(current_user.id, :include => :account)
    @account = @user.account
    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html {redirect_to @account, :notice => "Cambios guardados correctamente"}
        format.json {head :no_content}
      else
        flash[:error] = "No fue posible guardar los cambios"
        format.html {render action: "show"}
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  def display_warning_if_account_inactive
    unless current_account.active?
      link = '<a href="#select-plan">seleccione un plan</a>'
      flash[:error] = "Su periodo de prueba terminó, por favor #{link}.".html_safe
    end
  end
  
end
