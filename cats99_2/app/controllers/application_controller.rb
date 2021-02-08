class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?

    def login_user!(user)
        login!(user)
        redirect_to cats_url
    end

    def login!(user)
        session[:session_token] = user.reset_session_token!
    end

    def current_user
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def logged_in?
        !!current_user
    end

    def redirect_if_logged_in
        if logged_in? 
            redirect_to cats_url
        end
    end

    def not_owner
        @cat = Cat.find(params[:id])
        unless @cat.owner = current_user
            redirect_to cats_url
        end
    end
end
