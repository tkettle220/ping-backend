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
      render json: ["Invalid username/password combination"], status: 401
    end

  end
end
