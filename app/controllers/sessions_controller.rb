class SessionsController < Devise::SessionsController
  before_action :authenticate_user!, only: :destroy
  prepend_before_action :verify_signed_out_user, only: :destroy

  def create
    user = User.find_by_email(params[:email])
    if user && user.valid_password?(params[:password])
      user.update(device_token: user.generate_jwt)
      data = {id: user.id, email: user.email, name: user.full_name, gender: user.gender, phone_number: user.phone_number, organization: (user.organization_name if user.organization.present?), token: user.generate_jwt}
      json_response(:ok, 200, "You have successfully logged-In!", data)
    else
      json_response(:unprocessable_entity, 422, "Email/Password is Invalid!", "")
    end
  end

  def destroy
    if !request.headers['Authorization'].present?
      json_response(:unprocessable_entity, 422, "Authorization token must exsist!", "")
    else
      if params[:user][:user_id]
        user = User.find_by_id(params[:user][:user_id])
        if user.present?
          JwtBlacklist.create({jti: request.headers['Authorization'], exp: Time.now})
          reset_session
          user.update({device_token: nil})
          json_response(:ok, 200, "You have successfully logout!", "")
        else
          json_response(:unprocessable_entity, 422, "User not found!", "")
        end
      else
        json_response(:unprocessable_entity, 422, "User not found!", "")
      end
    end
  end

  private

    def verify_signed_out_user
    end

end