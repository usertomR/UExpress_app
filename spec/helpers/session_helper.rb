require 'rails_helper'

RSpec.describe "<helper>Session", type: :helper do
  before do
    @user = FactoryBot.create(:user, :activated)
  end

  describe "current_user" do
    before do
      remember(@user)
    end

    it "current_user returns right when session is nil" do
      expect(current_user).to eq @user
      expect(is_logged_in?).to be_truthy
    end

    it "current_user returns nil when remember digest is wrong" do
      user.update_attribute(:remember_digest, User.digest(User.new_token))
      expect(current_user).to eq nil
    end
  end
end
