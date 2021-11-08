class UsersController < ApplicationController
  
    skip_before_action :only_signed_in, only: [:new, :create, :confirm]
    before_action :only_signed_out, only: [:new, :create, :confirm]
  
  
    def new
      @user = User.new
    end
    
    def create
      user_params = params.require(:user).permit(:username, :email, :password, :password_confirmation)
      @user = User.new(user_params)
      @user.recover_password = nil
  
      if @user.valid?
        @user.save
        UserMailer.with(user: @user).confirm.deliver_now 
        redirect_to new_user_path, success: "Votre compte a bien été crée, vous devriez recevoir un email pour confirmer votre compte"
  
        # render "new" #en trop
  
        else 
          render "new"
  
      end
  
  
    end