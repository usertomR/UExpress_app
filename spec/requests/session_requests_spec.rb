require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<request>session", type: :request do
  let(:user) { FactoryBot.create(:user, :activated) }

  describe "DELETE /logout" do
    it "redirects to root_path" do
      post login_path, params: { session: {
        email: user.email,
        password: user.password
      } }
      delete logout_path
      aggregate_failures do
        expect(response).to redirect_to root_path
        expect(is_logged_in?).to be_falsy
      end
    end

    it "succeeds logout when user logs out on multiple tabs" do
      delete logout_path
      aggregate_failures do
        expect(response).to redirect_to root_path
        expect(is_logged_in?).to be_falsy
      end
    end
  end

  describe "remember me" do
    it "remembers the cookie when user checks the Remember Me check box" do
      log_in_as(user, remember_me: '1')
      expect(cookies[:remember_token]).not_to eq nil
    end

    it "does not remembers the cookie when user does not checks the Remember Me check box" do
      log_in_as(user, remember_me: '0')
      expect(cookies[:remember_token]).to eq nil
    end
  end

  describe "frendly forwarding" do
    let(:user) { FactoryBot.create(:user, :activated) }

    it "succeeds" do
      get edit_user_path(user)
      log_in_as(user)
      expect(response).to redirect_to edit_user_path(user)
    end
  end
end
