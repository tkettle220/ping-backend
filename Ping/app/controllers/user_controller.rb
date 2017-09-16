class UserController < ApplicationController

  def create
    @user = User.new(user_params)
    @user.visible_radius = 5;
    graph = Koala::Facebook::API.new(@user.session_token)
    @user.name = graph.get_object("me")["name"]
    @user.pro_pic_url = "http://graph.facebook.com/#{@user.facebook_id}/picture"
    if @user.save
      render
    else
      render json: @user.errors.full_messages
    end
  end

  private

  def user_params
    params.require(:user).permit(:facebook_id, :session_token)
  end
end
