module Settings
  class UsersController < ApplicationController
    before_filter :user, only: [:edit, :update, :destroy]

    def index
      @users = current_studio.users
    end

    def new
      @user = current_studio.users.build
    end

    def create
      @user = current_studio.users.build(permitted_params)
      if @user.save
        redirect_to settings_users_url, flash: { success: 'User successfully created.' }
      else
        render :new
      end
    end

    def edit
    end

    def update
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end

      if @user.update_attributes(permitted_params)
        redirect_to settings_users_url, flash: { success: 'User successfully updated.' }
      else
        render :edit
      end
    end

    def destroy
      if @user.destroy
        redirect_to settings_users_url, flash: { success: 'User successfully deleted.' }
      end
    end

    private

    def user
      @user = current_studio.users.find(params[:id])
    end

    def permitted_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation, :phone, :owner)
    end
  end
end
