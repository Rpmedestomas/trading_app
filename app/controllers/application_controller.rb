class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameteres, if: :devise_controller?

    protected

    def configure_permitted_parameteres
        devise_parameter_sanitizer.permit(:sign_up, keys: [:role_id, :full_name])
    end
end
