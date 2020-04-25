class UserMailer < ApplicationMailer

  def forgot_password_token(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: "Password reset request!")
  end
end