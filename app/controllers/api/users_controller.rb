require "redis"

class Api::UsersController < ApplicationController

  def update
    #location
    #automatically track the users location, used by ping in the background
    # location = Location.create!(latitude: params[:lat].to_f, longitude: params[:lng].to_f)
    # location.save!
    @user = User.find_by_session_token(params[:session_token])
    if @user
      location = @user.location
      if location
        location.update_attributes(location_params)
      else
        location = Location.create!(latitude: params[:lat].to_f, longitude: params[:lng].to_f)
        location.save!
        @user.location_id = location.id
      end
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
    #Expects a session_token, a friend fb id, and emergency
    @user = User.find_by_session_token(params[:session_token])
    @emergency = params[:emergency]
    if @user
      @friend = User.find_by_facebook_id(params[:friend_facebook_id])
      if @friend && @friend.friends.include?(@user)
        redis = Redis.current
        friend_pings_string = redis.get(@friend.facebook_id)
        #create ping object
        ping = {
          from: @user.facebook_id,

          time: Time.now.to_i,
          emergency: @emergency,
          status: false
        }

        if @emergency == "true" || (@friend.location && @friend.location.distance_from(@user.location) <= @friend.visible_radius)
          ping[:location] = {
                      lat: @user.location.latitude,
                      lng: @user.location.longitude
                    }
          ping[:status] = true
        end


        if friend_pings_string && friend_pings_string != ""
          #push another ping to the existing array
          friend_pings_array = JSON.parse(friend_pings_string)
          friend_pings_array.push(ping)
          redis.set(@friend.facebook_id, friend_pings_array.to_json)
        else
          #set to an array containing new ping
          redis.set(@friend.facebook_id, [ping].to_json)
        end

        render "api/users/pinged_friend"
      else
        render json: ["Friend not found"], status: 401
      end
    else
      render json: ["Invalid session token"], status: 401
    end

  end

  def get_pings
    #render the json from redis
    #clear redis
    redis = Redis.current
    @user = User.find_by_session_token(params[:session_token])
    if @user
      pings = redis.get(@user.facebook_id)
      if pings && pings != ""
        render json: JSON.parse(pings)
        redis.set(@user.facebook_id, "")
      else
        render json: []
      end
    else
      render json: ["Invalid session token"], status: 401
    end

  end

  private

  def location_params
    params.permit(:latitude, :longitude)
  end


end
