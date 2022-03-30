require 'rails_helper'

RSpec.describe "<model>Message", type: :model do
  describe ":validation" do
    before do
      @message = FactoryBot.create(:message)
    end

    it "is vaild" do
      expect(@message).to be_valid
    end

    it "is invalid without user_id" do
      @message.user_id = nil
      expect(@message).to be_invalid
    end

    it "is invalid without room_id" do
      @message.room_id = nil
      expect(@message).to be_invalid
    end

    it "is invalid without content" do
      @message.content = "      "
      expect(@message).to be_invalid
    end
  end
end
