require 'rails_helper'

RSpec.describe "<request>UsersController", type: :request do
  context ":Redirect" do
    it "must redirect [index] when not logged in" do
      get '/users'
      expect(response).to redirect_to '/login'
    end
  end

  context ":Not redirect and not be access restriction" do
    it "must get new" do
      get '/signup'
      expect(response).to have_http_status(200)
    end
  end

  context ":Not redirect and be access restriction" do
    before do
      @user = FactoryBot.create(:user)
    end
  end
end
