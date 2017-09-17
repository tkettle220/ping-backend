class Api::SessionsController < ApplicationController

  def create
    @user = current_user
    if @user
      @user.session_token = params[:session_token]
      @user.save!
      render "api/users/show"
    else
      make_user
    end
  end

  def make_user
    @user = User.new({session_token: params[:session_token]})
    graph = Koala::Facebook::API.new(@user.session_token)
    @user.fill_user_data(graph)
    if @user.save
      @user.add_friends(graph)
      render "api/users/show"
    else
      render json: @user.errors.full_messages, status: 422
    end
  end


  def current_user
    facebook_id = params[:facebook_id]
    return User.find_by(facebook_id: facebook_id)
  end

  private

  # def user_params
  #   params.permit(:session_token, :facebook_id)
  # end

end
