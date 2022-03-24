class RoomsController < ApplicationController
  def create
    @room = Room.create
    @sended_user_entry = Entry.create(room_id: @room.id, user_id: params[:sended_user_id])
    @sending_user_entry = Entry.create(room_id: @room.id, user_id: params[:sending_user_id])
    redirect_to room_path(@room)
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages.created_asc
    @message = Message.new
    @entries = @room.entries
  end

  def index
  end
end
