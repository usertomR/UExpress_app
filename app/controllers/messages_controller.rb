class MessagesController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    @message = Message.new(message_params)
    if @message.save
      date = ApplicationRecord.date_expression_change(@message.created_at)
      ActionCable.server.broadcast 'message_channel', message: @message, post_date: date, post_user: current_user
    else
      flash[:danger] = "メッセージを記入して下さい"
      redirect_to room_path(params[:message][:room_id])
    end
  end

  private

  def message_params
    params.require(:message).permit(:user_id, :room_id, :content)
  end
end
