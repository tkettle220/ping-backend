class Api::UsersController < ApplicationController

  def update
    location = Location.create!(latitude: params[:lat], longitude: params[:lng])
    
  end

  private

  def user_params
    params.permit(:lat, :lng)
  end

end
