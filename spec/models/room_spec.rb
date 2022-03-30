require 'rails_helper'

RSpec.describe "<model>Room", type: :model do
  describe ":validation" do
    before do
      @room = FactoryBot.create(:room)
    end

    it "is valid" do
      expect(@room).to be_valid
    end
  end
end
