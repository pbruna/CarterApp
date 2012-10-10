# encoding: utf-8

class AccountsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:new, :create]
  skip_before_filter :block_inactive_accounts!
  before_filter :display_warning_if_account_inactive, :except => [:new, :create]

  def index
    redirect_to account_path(current_account) unless current_user.root?
    @accounts = Account.all.order_by(:name => :desc).to_a
  end

  def show
    @user = User.find(current_user.id)
    @account = current_account
  end

  def new
    @account = Account.new
    @account.users.build
    
    respond_to do |format|
      format.html
      format.js 
    end
    
  end

  def create
    @account = Account.new(params[:account])
    respond_to do |format|
      if @account.save
        format.html {redirect_to account_path(@account), :notice => "Cuenta creada correctamente"}
        format.json {head :no_content}
        format.js
      else
        flash[:error] = "No fue posible crear a cuenta"
        format.html {render action: "new" }
        format.json { render json: @account.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update_plan
    @user = User.find(current_user.id)
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
    @user = User.find(current_user.id)
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
