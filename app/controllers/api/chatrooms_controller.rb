class Api::ChatroomsController < ApplicationController
  def create
    @chatroom = Chatroom.new({chatname: params[:chatname]})
    if @chatroom.save
      render :show
    else
      render json: @chatroom.errors.full_messages, status: 422
    end
  end

  def show
    @chatroom = Chatroom.find_by_id(params[:id])
  end
end
