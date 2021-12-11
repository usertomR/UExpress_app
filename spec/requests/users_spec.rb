require 'rails_helper'

RSpec.describe "<request>Users", type: :request do
  describe "POST /users" do
    let(:user) { FactoryBot.attributes_for(:user) } # attributes_forはハッシュを返す
    it "adds new user with correct signup information" do
    end
  end
end
