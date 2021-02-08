class SessionController < ApplicationController
    before_action :redirect_if_logged_in, only: [:new, :create]

    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.find_by_credentials(
            params[:session][:user][:user_name],
            params[:session][:user][:password]
            )
        if @user
            login!(@user)
            redirect_to cats_url
        else
            redirect_to new_session_url
        end
    end


    def destroy
        if current_user 
                current_user.reset_session_token!
        end
        session[:session_token] = nil
    end
end