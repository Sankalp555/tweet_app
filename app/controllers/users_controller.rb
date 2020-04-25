class UsersController < ApplicationController
  before_action :authenticate_user!

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :gender, :email, :password, :device_token, :phone_number, :organization_id)
  end  
end
