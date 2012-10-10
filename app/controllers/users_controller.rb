class UsersController < ApplicationController
  # before_filter :admin?, :except => [:index, :edit]
  # before_filter :admin_or_himself?, :only => [:edit]

  # def index
  #     @users = User.all
  #   end
  # 
  #   def edit
  #     @user = User.find(params[:id])
  #   end
  #   
  #   def show
  #     id = params[:id] || current_user.id
  #     @user = User.find(id)
  #   end

  # def new
  #   @user = User.new
  # end
  # 
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice]="Usuario creado correctamente"
      redirect_to account_path(current_account.id)
    else
      flash[:error]="No fue posible agregar el usuario  #{ @user.errors.to_hash }" 
      redirect_to account_path(current_account.id)
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
      else
        flash[:error] = "No fue posible guardar los cambios"
        format.html {redirect_to account_path(@account)}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # def destroy
  #     @user = User.find(params[:id])
  #     respond_to do |format|
  #       if @user.destroy
  #         format.html {redirect_to users_path(), :notice => "Usuario eliminado correctamente"}
  #         format.json {head :no_content}
  #       else
  #         flash[:error] = @user.errors[:base].first
  #         format.html {redirect_to users_path}
  #         format.json {render json: @user.errors, status: :unprocessable_entity}
  #       end
  #     end
  #   end

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
