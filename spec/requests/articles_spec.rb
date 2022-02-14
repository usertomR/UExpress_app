require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<request>Articles", type: :request do
  # new,createアクション
  # そもそも、アカウント有効化していないとログインできないので、
  # 有効化されていないユーザが作成する心配はない
  describe ":when you want to create an article" do
    context "you can't create" do
      it "because you don't login before access new acion" do
        @user = FactoryBot.create(:user, :activated)
        get '/articles/new'
        expect(response).to redirect_to '/login'
      end

      it "because you don't login before access create acion" do
        @user = FactoryBot.create(:user, :activated)
        post articles_path
        expect(response).to redirect_to '/login'
      end

      it "because your account are not activated" do
        @user = FactoryBot.create(:user)
        get '/articles/new'
        expect(response).to redirect_to '/login'
      end

      it "because you input wrong infomation" do
        @user = FactoryBot.create(:user, :activated)
        log_in_as(@user)
        post articles_path, params: { article: {
          title: "   ",
          Eschool_level: '0',
          JHschool_level: '0',
          Hschool_level: '0',
          articletext: "false"
        } }
        expect(response).to have_http_status(200)
      end
    end

    context "you can create" do
      it "because you input right infomation" do
        @user = FactoryBot.create(:user, :activated)
        log_in_as(@user)
        post articles_path, params: { article: {
          title: "success!",
          accuracy_text: '4',
          difficultylevel_text: '4',
          Eschool_level: '1',
          JHschool_level: '1',
          Hschool_level: '1',
          articletext: "text"
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
      post articles_path, params: { article: {
        title: "success!",
        accuracy_text: '4',
        difficultylevel_text: '4',
        Eschool_level: '1',
        JHschool_level: '1',
        Hschool_level: '1',
        articletext: "text"
      } }
    end
    it "can be accessed by author(status: login)" do
      get article_path(@user)
      expect(response).to have_http_status(200)
    end

    it "can be accessed by no-author(status :login)" do
      delete logout_path
      @another = FactoryBot.create(:user, :activated)
      log_in_as(@another)
      get article_path(@user)
      expect(response.body).to include "記事投稿リスト"
    end

    it "can be accessed by anyone(status :not-activated)" do
      delete logout_path
      @anyone = FactoryBot.create(:user)
      get article_path(@user)
      expect(response).to have_http_status(200)
    end
  end

  # browsingアクション
  describe ":when browse an article" do
    before do
      @user = FactoryBot.create(:user, :activated)
      log_in_as(@user)
      post articles_path, params: { article: {
        title: "success!",
        accuracy_text: '4',
        difficultylevel_text: '4',
        Eschool_level: '1',
        JHschool_level: '1',
        Hschool_level: '1',
        articletext: "text"
      } }
    end
    it "anyone can browse all articles(not activated)" do
      delete logout_path
      @anyone = FactoryBot.create(:user)
      get browsing_article_path(@user.articles[0].id)
      expect(response).to have_http_status(200)
    end
  end

  # edit,updateアクション
  describe ":when you edit/update an article" do
    before do
      @user = FactoryBot.create(:user, :activated)
      log_in_as(@user)
      post articles_path, params: { article: {
        title: "success!",
        accuracy_text: '4',
        difficultylevel_text: '4',
        Eschool_level: '1',
        JHschool_level: '1',
        Hschool_level: '1',
        articletext: "text"
      } }

      @another = FactoryBot.create(:user, :activated)
    end

    context "you can't edit" do
      it "because you don't login" do
        delete logout_path
        get edit_article_path(@user.articles[0].id)
        expect(response).to redirect_to '/login'
      end

      it "because you are not it's writer" do
        delete logout_path
        log_in_as(@another)
        get edit_article_path(@user.articles[0].id)
        expect(response).to redirect_to root_path
      end
    end

    context "you can't update" do
      it "because you don't login" do
        delete logout_path
        patch article_path(@user.articles[0].id), params: { article: {
          title: "retry!",
          accuracy_text: '4',
          difficultylevel_text: '5',
          Eschool_level: '0',
          JHschool_level: '1',
          Hschool_level: '1',
          articletext: "update"
        } }
        expect(response).to redirect_to '/login'
      end

      it "because you are not it's writer" do
        delete logout_path
        log_in_as(@another)
        patch article_path(@user.articles[0].id), params: { article: {
          title: "retry!",
          accuracy_text: '4',
          difficultylevel_text: '5',
          Eschool_level: '0',
          JHschool_level: '1',
          Hschool_level: '1',
          articletext: "update"
        } }
        expect(response).to redirect_to root_path
      end

      it "because you input worng infomation" do
        patch article_path(@user.articles[0].id), params: { article: {
          title: "  ",
          accuracy_text: '4',
          difficultylevel_text: '5',
          Eschool_level: '0',
          JHschool_level: '1',
          Hschool_level: '1',
          articletext: "update"
        } }
        expect(response).to have_http_status(200)
      end
    end

    context "you can edit/update" do
      it "because you input right infomation" do
        patch article_path(@user.articles[0].id), params: { article: {
          title: "Request_spec",
          accuracy_text: '5',
          difficultylevel_text: '2',
          Eschool_level: '1',
          JHschool_level: '1',
          Hschool_level: '1',
          articletext: "RSpec!"
        } }
        expect(response).to redirect_to browsing_article_path(@user.articles[0].id)
      end
    end
  end

  # destroyアクション
  describe ":when you delete an article" do
    before do
      @user = FactoryBot.create(:user, :activated)
      log_in_as(@user)
      post articles_path, params: { article: {
        title: "success!",
        accuracy_text: '4',
        difficultylevel_text: '4',
        Eschool_level: '1',
        JHschool_level: '1',
        Hschool_level: '1',
        articletext: "text"
      } }
    end

    context "you can't delete" do
      it "because you don't login" do
        delete logout_path
        delete article_path(@user.articles[0].id)
        expect(response).to redirect_to '/login'
      end

      it "because article you want to delete is not yours" do
        delete logout_path
        @another = FactoryBot.create(:user, :activated)
        log_in_as(@another)
        delete article_path(@user.articles[0].id)
        expect(response).to redirect_to root_path
      end
    end

    context "you can delete" do
      it "because you are the writer of the article" do
        delete article_path(@user.articles[0].id)
        expect(response).to redirect_to request.referer || root_path
      end
    end
  end
end
