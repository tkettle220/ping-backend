require 'exponent-server-sdk'
require_relative "../../models/concerns/exponent-server-sdk.rb"

class Api::TokensController < ApplicationController
  def create
    @user = User.find_by_session_token(params[:session_token])
    if @user
      # You probably actually want to associate this with a user,
      # otherwise it's not particularly useful
      @token = Token.where(value: params[:token][:value]).first

      if @token.present?
        render json: {success: true}
      else
        @token = Token.new(value: params[:token][:value])
        @token.user = @user
        if @token.save
          messages = [{
            to: @token.value,
            sound: "default",
            body: 'Welcome to Ping',
            data: {message: 'Welcome to Ping'}
          }]

          exponent.publish messages
          render json: {success: true}
        else
          render json: ["Token creation failed"], status: 401
          return
        end
      end
    else
      render json: ["Invalid session token"], status: 401
    end
  end

  def send_push
    @friend = User.find_by_facebook_id(params[:friend_facebook_id])
    friend_push_token = @friend.token
    data = params[:data]

    messages = [{
      to: friend_push_token.value,
      sound: "default",
      body: data["message"],
      data: data
    }]

    exponent.publish messages

    render json: {success: true}

  end

  private

  def token_params
    params.require(:token).permit(:value)
  end

  def exponent
    @exponent ||= Exponent::Push::Client.new
  end



end
