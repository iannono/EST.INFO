class UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path, notice: 'You are successfully subscribed.' }
      else
        format.html { redirect_to root_path, alert: @user.errors.full_messages.join(',') }
      end
    end
  end

  private
    def user_params
      params.require(:user).permit(:email)
    end
end
