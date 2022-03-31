require 'rails_helper'

RSpec.describe "<model>Entry", type: :model do
  describe ":validation" do
    before do
      @entry = FactoryBot.create(:entry)
    end

    it "is vaild" do
      expect(@entry).to be_valid
    end

    it "is invalid without user_id" do
      @entry.user_id = nil
      expect(@entry).to be_invalid
    end

    it "is invalid without room_id" do
      @entry.room_id = nil
      expect(@entry).to be_invalid
    end
  end
end
