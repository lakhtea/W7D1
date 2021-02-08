class UsersController < ApplicationController
    before_action :redirect_if_logged_in

    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.create(user_params)
        if @user.save
            login_user!(@user)
            redirect_to cats_url
        else
            # flash errors
            render :new
        end
    end

    def user_params
        params.require(:user).permit(:user_name, :password, :password_digest, :session_token)
    end 
end