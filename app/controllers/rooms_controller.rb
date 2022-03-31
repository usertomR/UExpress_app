class RoomsController < ApplicationController
  before_action :logged_in_user, only: [:create, :show]
  before_action :correct_create, only: [:create]
  before_action :correct_show, only: [:show]

  def create
    @room = Room.create
    @sended_user_entry = Entry.create(room_id: @room.id, user_id: params[:sended_user_id])
    @sending_user_entry = Entry.create(room_id: @room.id, user_id: params[:sending_user_id])
    redirect_to room_path(@room)
  end

  def show
    @messages = @room.messages.created_asc
    @message = Message.new
  end

  def index
  end

  private

  def correct_create
    unless params[:sending_user_id] == current_user.id.to_s && params[:sended_user_id].to_i.positive?
      redirect_to(root_path)
    end
  end

  # @entriesは、@room(ダイレクトメールのチャットルーム)のidと@roomに関係する人のidを含む。
  # @room内ではちょうど2人で話し合う仕様なので、ifの条件式は以下のようになる
  def correct_show
    @room = Room.find(params[:id])
    @entries = @room.entries
    if @entries[0].user != current_user && @entries[1].user != current_user
      redirect_to(root_path)
    end
  end
end
