require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<request>Questions", type: :request do
  describe ":when you want to create a question" do
    context "you can't create" do
      it "because you don't login before access new acion" do
        @user = FactoryBot.create(:user, :activated)
        get '/questions/new'
        expect(response).to redirect_to '/login'
      end

      it "because you don't login before access create acion" do
        @user = FactoryBot.create(:user, :activated)
        post questions_path
        expect(response).to redirect_to '/login'
      end

      it "because your account are not activated" do
        @user = FactoryBot.create(:user)
        get '/questions/new'
        expect(response).to redirect_to '/login'
      end

      it "because you input wrong infomation" do
        @user = FactoryBot.create(:user, :activated)
        log_in_as(@user)
        post articles_path, params: { question: {
          title: "   ",
          Eschool_level: '0',
          JHschool_level: '0',
          Hschool_level: '0',
          questiontext: "false"
        } }
        expect(response).to have_http_status(200)
      end
    end

    context "you can create" do
      it "because you input right infomation" do
        @user = FactoryBot.create(:user, :activated)
        log_in_as(@user)
        post articles_path, params: { question: {
          title: "success!",
          accuracy_text: '4',
          difficultylevel_text: '4',
          Eschool_level: '1',
          JHschool_level: '1',
          Hschool_level: '1',
          questiontext: "text"
        } }
        expect(response).to redirect_to root_path
      end
    end
  end
end
