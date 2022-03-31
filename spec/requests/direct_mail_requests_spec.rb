require 'rails_helper'
require './spec/support/test_helper'

# ダイレクトメールでは、RoomモデルとEntryモデルとMessageモデルが関係する。
RSpec.describe "<request>Direct_mail", type: :request do
  # チャットルームに入るところまでを想定/ RoomモデルとEntryモデル
  before do
    @user = FactoryBot.create(:user, :activated)
    @another = FactoryBot.create(:user, :activated)
    @third_person = FactoryBot.create(:user, :activated)
  end

  describe ":About entering&creating room" do
    describe "if @user do not log in" do
      it "@user can't enter&create room" do
        post rooms_path
        expect(response).to redirect_to '/login'
      end
    end

    describe "if @user log in" do
      before do
        log_in_as(@user)
      end

      describe "and wants to talk to @another first time" do
        it "@user can create&enter room to talk to @anoter" do
          post rooms_path, params: {
            sending_user_id: @user.id,
            sended_user_id: @another.id
          }
          aggregate_failures do
            expect(Room.count).to eq 1
            @room = Room.take
            expect(response).to redirect_to room_path(@room)
          end
        end
      end

      describe "and wants to talk to @another who has talked with @user more than one time" do
        before do
          post rooms_path, params: {
            sending_user_id: @user.id,
            sended_user_id: @another.id
          }
          @room = Room.take
          get root_path
        end

        it "@user can enter room to talk to @anoter" do
          get room_path(@room)
          expect(request.fullpath).to eq room_path(@room)
        end
      end

      # sending_user_idはログイン中のユーザで、sended_user_idはその他のユーザでなければならない
      describe "and wants to create the room which is not appropriate forcibly," do
        it "@user can't create&enter the room with two other person's id" do
          post rooms_path, params: {
            sending_user_id: @third_person.id,
            sended_user_id: @another.id
          }
          aggregate_failures do
            expect(Room.count).to eq 0
            expect(response).to redirect_to root_path
          end
        end

        it "@user can't create&enter the room with two same id(@user.id)" do
          expect do
            post rooms_path, params: {
              sending_user_id: @user.id,
              sended_user_id: @user.id
            }
          end.to raise_error(ActiveRecord::RecordNotUnique)
        end

        it "@user can't create&enter the room without appropriate sended_user_id" do
          post rooms_path, params: {
            sending_user_id: @user.id,
            sended_user_id: "   "
          }
          aggregate_failures do
            expect(Room.count).to eq 0
            expect(response).to redirect_to root_path
          end
        end
      end

      describe "and wants to enter the room which is not related to @user forcibly," do
        before do
          delete logout_path
          log_in_as(@another)
          post rooms_path, params: {
            sending_user_id: @another.id,
            sended_user_id: @third_person.id
          }
          @room = Room.take
          delete logout_path
          log_in_as(@user)
        end

        it "@user can't enter the room and redirect to root_path page" do
          get room_path(@room)
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  # チャットルームでメッセージを送ることを想定/Messageモデル
  describe ":About creating a message to @another" do
    before do
      log_in_as(@another)
      post rooms_path, params: {
        sending_user_id: @another.id,
        sended_user_id: @user.id
      }
      @room = Room.first
      delete logout_path
    end

    describe "if @user do not log in" do
      it "@user can't create a message" do
        post messages_path, params: { message: {
          user_id: @user.id.to_s,
          room_id: @room.id.to_s,
          content: "Test"
        } }
        expect(response).to redirect_to login_path
      end
    end

    describe "if @user log in and create a blank message" do
      it "The record of message model do not increase" do
        log_in_as(@user)
        expect do
          post messages_path, params: { message: {
            user_id: @user.id.to_s,
            room_id: @room.id.to_s,
            content: "       "
          } }
        end.to change(Message, :count).by(0)
      end
    end

    describe "if @user log in and create a message which is not blank" do
      it "The record of message model increases by 1" do
        log_in_as(@user)
        expect do
          post messages_path, params: { message: {
            user_id: @user.id.to_s,
            room_id: @room.id.to_s,
            content: "Test"
          } }
        end.to change(Message, :count).by(1)
      end
    end
  end
end
