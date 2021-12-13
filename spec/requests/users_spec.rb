require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<request>Users", type: :request do
  describe "POST /users" do
    let(:user) { FactoryBot.attributes_for(:user) } # attributes_forはハッシュを返す
    it "adds new user with correct signup information" do
      aggregate_failures do
        expect do
          post users_path, params: { user: user }
        end.to change(User, :count).by(1)
        expect(ActionMailer::Base.deliveries.size).to eq(1)
        expect(response).to redirect_to root_url
        expect(is_logged_in?).to be_falsy
      end
    end
  end

  describe "PATCH /users/:id" do
    let(:user) { FactoryBot.create(:user, :activated) }
    before { log_in_as(user) }

    it "fails edit with wrong information" do
      patch user_path(user), params: { user: {
        name: " ",
        email: "foo@invalid",
        password: "foo",
        password_confirmation: "bar"
      } }
      expect(response).to have_http_status(200)
    end

    it "succeeds edit with correct information" do
      patch user_path(user), params: { user: {
        name: "Foo Bar",
        email: "foo@bar.com",
        password: "",
        password_confirmation: ""
      } }
      expect(response).to redirect_to user_path(user)
    end
  end

  describe "GET /users" do
    it "redirects login when not logged in" do
      get users_path
      expect(response).to redirect_to login_path
    end
  end

  describe " DELETE /users/:id" do
    let!(:user) { FactoryBot.create(:user, :activated) }
    let!(:admin_user) { FactoryBot.create(:user, :activated, :admin) }

    it "fails when not admin" do
      log_in_as(user)
      aggregate_failures do
        expect do
          delete user_path(admin_user)
        end.to change(User, :count).by(0)
        expect(response).to redirect_to root_path
      end
    end

    it "succeds when user is administrator" do
      log_in_as(admin_user)
      aggregate_failures do
        expect do
          delete user_path(user)
        end.to change(User, :count).by(-1)
        expect(response).to redirect_to users_path
      end
    end
  end

  describe "before_action: :logged_in_user" do
    let(:user) { FactoryBot.create(:user, :activated) }

    it "redirects edit when not logged in" do
      get edit_user_path(user)
      expect(response).to redirect_to login_path
    end

    it "redirects update when not logged in" do
      patch user_path(user), params: { user: {
        name: user.name,
        email: user.email
      } }
      expect(response).to redirect_to login_path
    end
  end

  describe "before_action: :correct_user" do
    before do
      @user = FactoryBot.create(:user, :activated)
      @other_user = FactoryBot.create(:user, :activated)
      log_in_as(@other_user)
    end

    it "redirects edit when logged in as wrong user" do
      get edit_user_path(@user)
      expect(response).to redirect_to root_path
    end

    it "redirects update when logged in as wrong user" do
      patch user_path(@user), params: { user: {
        name: @user.name,
        email: @user.email
      } }
      expect(response).to redirect_to root_path
    end
  end
end
