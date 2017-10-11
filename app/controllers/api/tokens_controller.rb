require 'exponent-server-sdk'

class Api::TokensController < ApplicationController
  def create
    @user = User.find_by_session_token(params[:session_token])
    if @user
      # You probably actually want to associate this with a user,
      # otherwise it's not particularly useful
      @token = Token.where(value: params[:token][:value]).first

      message = ''
      if @token.present?
        message = 'Welcome back!'
      else
        @token = Token.new(value: params[:token][:value])
        @token.user = @user
        if @token.save
          message = 'Welcome to Expo'
        else
          render json: ["Token creation failed"], status: 401
          return
        end
      end

      exponent.publish(
        exponentPushToken: @token.value,
        message: message,
        data: {a: 'b'}, # Data is required, pass any arbitrary data to include with the notification
      )

      render json: {success: true}
    else
      render json: ["Invalid session token"], status: 401
    end
  end

  private

  def token_params
    params.require(:token).permit(:value)
  end

  def exponent
    @exponent ||= Exponent::Push::Client.new
  end



end
