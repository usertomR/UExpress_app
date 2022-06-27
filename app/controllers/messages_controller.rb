class MessagesController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    @message = Message.new(message_params)
    unless @message.save
      flash[:danger] = "メッセージを記入して下さい"
    end
    if @message.save
      ActionCable.server.broadcast 'message_channel', content: @message
    end
    # redirect_to room_path(params[:message][:room_id])
    # 上の行を入れないと、連続でメッセージを送信できない。
  end

  private

  def message_params
    params.require(:message).permit(:user_id, :room_id, :content)
  end
end
