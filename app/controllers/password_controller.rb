class PasswordController < ApplicationController

  def forgot
    if params[:user][:email].blank? # check if email is present
      return render json: {error: 'Email not present'}
    end
    user = User.find_by(email: params[:user][:email]) # if present find user by email
    if user.present?
      user.generate_password_token! #generate pass token
      # SEND EMAIL HERE
      UserMailer.forgot_password_token(user.id).deliver_now
      json_response(:ok, 200, "A Token has been sent to your email id!", "")
    else
      json_response(:not_found, 404, "Email address not found. Please check and try again!","")
    end
  end


  def reset
    token = params['user']['token'].to_s
    user = User.find_by(reset_password_token: token)
    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:user][:password])
        json_response(:ok, 200, "You have successfully updated your password!","")
      else
        json_response(:unprocessable_entity, 422, user.errors.full_messages,"")
      end
    else
      json_response(:not_found, 404, "Link not valid or expired. Try generating a new link!","")
    end
  end
end
