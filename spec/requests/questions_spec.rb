require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<request>Questions", type: :request do
  # new,createアクション
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
        post questions_path, params: { question: {
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
        post questions_path, params: { question: {
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

  # showアクション
  describe ":GET /show" do
    before do
      @user = FactoryBot.create(:user, :activated)
      log_in_as(@user)
      post questions_path, params: { question: {
        title: "success!",
        accuracy_text: '4',
        difficultylevel_text: '4',
        Eschool_level: '1',
        JHschool_level: '1',
        Hschool_level: '1',
        questiontext: "text"
      } }
    end
    it "can be accessed by author(status: login)" do
      get question_path(@user)
      expect(response).to have_http_status(200)
    end

    it "can be accessed by no-author(status :login)" do
      delete logout_path
      @another = FactoryBot.create(:user, :activated)
      log_in_as(@another)
      get question_path(@user)
      expect(response.body).to include "記事投稿リスト"
    end

    it "can be accessed by anyone(status :not-activated)" do
      delete logout_path
      @anyone = FactoryBot.create(:user)
      get question_path(@user)
      expect(response).to have_http_status(200)
    end
  end

  # browsingアクション
  describe ":when browse a question" do
    before do
      @user = FactoryBot.create(:user, :activated)
      log_in_as(@user)
      post questions_path, params: { question: {
        title: "success!",
        accuracy_text: '4',
        difficultylevel_text: '4',
        Eschool_level: '1',
        JHschool_level: '1',
        Hschool_level: '1',
        questiontext: "text"
      } }
    end
    it "anyone who login(include test login) can browse all questions" do
      @anyone = FactoryBot.create(:user)
      get browsing_question_path(@user.questions[0].id)
      expect(response).to have_http_status(200)
    end
  end

  # edit,updateアクション
  describe ":when you edit/update a question" do
    before do
      @user = FactoryBot.create(:user, :activated)
      log_in_as(@user)
      post questions_path, params: { question: {
        title: "success!",
        accuracy_text: '4',
        difficultylevel_text: '4',
        Eschool_level: '1',
        JHschool_level: '1',
        Hschool_level: '1',
        questiontext: "text"
      } }

      @another = FactoryBot.create(:user, :activated)
    end

    context "you can't edit" do
      it "because you don't login" do
        delete logout_path
        get edit_question_path(@user.questions[0].id)
        expect(response).to redirect_to '/login'
      end

      it "because you are not it's writer" do
        delete logout_path
        log_in_as(@another)
        get edit_question_path(@user.questions[0].id)
        expect(response).to redirect_to root_path
      end
    end

    context "you can't update" do
      it "because you don't login" do
        delete logout_path
        patch question_path(@user.questions[0].id), params: { question: {
          title: "retry!",
          accuracy_text: '4',
          difficultylevel_text: '5',
          Eschool_level: '0',
          JHschool_level: '1',
          Hschool_level: '1',
          questiontext: "update"
        } }
        expect(response).to redirect_to '/login'
      end

      it "because you are not it's writer" do
        delete logout_path
        log_in_as(@another)
        patch question_path(@user.questions[0].id), params: { question: {
          title: "retry!",
          accuracy_text: '4',
          difficultylevel_text: '5',
          Eschool_level: '0',
          JHschool_level: '1',
          Hschool_level: '1',
          questiontext: "update"
        } }
        expect(response).to redirect_to root_path
      end

      it "because you input worng infomation" do
        patch question_path(@user.questions[0].id), params: { question: {
          title: "  ",
          accuracy_text: '4',
          difficultylevel_text: '5',
          Eschool_level: '0',
          JHschool_level: '1',
          Hschool_level: '1',
          questiontext: "update"
        } }
        expect(response).to have_http_status(200)
      end
    end

    context "you can edit/update" do
      it "because you input right infomation" do
        patch question_path(@user.questions[0].id), params: { question: {
          title: "Request_spec",
          accuracy_text: '5',
          difficultylevel_text: '2',
          Eschool_level: '1',
          JHschool_level: '1',
          Hschool_level: '1',
          questiontext: "RSpec!"
        } }
        expect(response).to redirect_to browsing_question_path(@user.questions[0].id)
      end
    end
  end

  # destroyアクション
  describe ":when you delete a question" do
    before do
      @user = FactoryBot.create(:user, :activated)
      log_in_as(@user)
      post questions_path, params: { question: {
        title: "success!",
        accuracy_text: '4',
        difficultylevel_text: '4',
        Eschool_level: '1',
        JHschool_level: '1',
        Hschool_level: '1',
        questiontext: "text"
      } }
    end

    context "you can't delete" do
      it "because you don't login" do
        delete logout_path
        delete question_path(@user.questions[0].id)
        expect(response).to redirect_to '/login'
      end

      it "because question you want to delete is not yours" do
        delete logout_path
        @another = FactoryBot.create(:user, :activated)
        log_in_as(@another)
        delete question_path(@user.questions[0].id)
        expect(response).to redirect_to root_path
      end
    end

    context "you can delete" do
      it "because you are the writer of the question" do
        delete question_path(@user.questions[0].id)
        expect(response).to redirect_to request.referer || root_path
      end
    end
  end
end
