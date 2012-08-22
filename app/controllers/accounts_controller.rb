class AccountsController < ApplicationController
  
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
  
end
