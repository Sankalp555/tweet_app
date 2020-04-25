class ApplicationController < ActionController::Base
  include Response
  include ExceptionHandler

  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user
  respond_to :json

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number, :gender, :organization_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :gender])
  end

  def authenticate_user
    if request.headers['Authorization'].present?
      token = request.headers['Authorization']
      begin
        jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first
        @current_user_id = jwt_payload['id']
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        head :unauthorized
      end
    end
  end

  def authenticate_user!(options = {})
    head :unauthorized unless signed_in?
  end

  def current_user
    @current_user ||= super || User.find(@current_user_id)
  end

  def signed_in?
    @current_user_id.present?
  end

  def validate_auth_token?
    if !request.headers["Authorization"].present?
      json_response(:unprocessable_entity, 422, "Auth token required!", "")
    else
      if JwtBlacklist.find_by(jti: request.headers["Authorization"]).present?
        json_response(:unauthorized, 400, "Auth token expired!", "")
      else
        return true
      end
    end
  end
end