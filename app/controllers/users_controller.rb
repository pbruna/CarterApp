class UsersController < ApplicationController
  # before_filter :admin?, :except => [:index, :edit]
  # before_filter :admin_or_himself?, :only => [:edit]


  def new
    @account = Account.find(params[:account_id])
    @user = @account.users.build
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        flash[:notice]="Usuario creado correctamente"
        format.html {redirect_to account_path(current_account.id)}
        format.js
      else
        @account = Account.find(@user.account_id)
        flash[:error]="No fue posible agregar el usuario  #{ @user.errors.to_hash }"
        format.html {redirect_to account_path(current_account.id)}
        format.js
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    @account = @user.account
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    params[:user].delete(:password) if params[:user][:password].blank?
    logger.debug(params)
    @user = User.find(params[:id])
    @account = @user.account
    respond_to do |format|
      if @user.update_attributes(params[:user])
        sign_in @user, :bypass => true
        format.html {redirect_to account_path(@account), :notice => "Cambios guardados correctamente"}
        format.json {head :no_content}
        format.js
      else
        flash[:error] = "No fue posible guardar los cambios"
        format.html {redirect_to account_path(@account)}
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.destroy
        format.html {redirect_to users_path(), :notice => "Usuario eliminado correctamente"}
        format.json {head :no_content}
        format.js
      else
        flash[:error] = @user.errors[:base].first
        format.html {redirect_to users_path}
        format.json {render json: @user.errors, status: :unprocessable_entity}
        format.js
      end
    end
  end

  private
    # def admin?
    #       return if current_user.admin?
    #       flash[:error] = "Usuario no es administrador"
    #       redirect_to users_path()
    #     end
    #
    #     def admin_or_himself?
    #       return if current_user.admin?
    #       return if current_user.id.to_s == params[:id]
    #       flash[:error] = "Usuario no es administrador"
    #       redirect_to users_path()
    #     end
end
