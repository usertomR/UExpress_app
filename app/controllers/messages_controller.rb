class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    unless @message.save
      flash[:danger] = "メッセージを記入して下さい"
    end
    redirect_to room_path(params[:message][:room_id])
  end

  private

  def message_params
    params.require(:message).permit(:user_id, :room_id, :content)
  end
end
