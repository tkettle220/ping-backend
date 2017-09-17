class Api::UsersController < ApplicationController

  def update
    location = Location.create!(latitude: params[:lat].to_f, longitude: params[:lng].to_f)
    location.save!
    @user = User.find_by_session_token(params[:session_token])
    if @user
      @user.location_id = location.id
      if @user.save
        render "api/users/show"
      else
        render json: @user.errors.full_messages, status: 422
      end
    else
      render json: ["Invalid session token"], status: 401
    end
  end

  def ping
    #first make sure the friend is actually friends with you
    #if the friend is within pingable distance, return the friend's name, pic, and location via JSON, otherwise, return json string "out_of_range"
    #Expects a session_token and a friend fb id
    @user = User.find_by_session_token(params[:session_token])
    if @user
      @friend = User.find_by_facebook_id(params[:friend_facebook_id])
      if @friend && @friend.friends.include?(@user)
          render "api/users/pinged_friend"
      else
        render json: ["Friend not found"], status: 401
      end
    else
      render json: ["Invalid session token"], status: 401
    end

  end


end
