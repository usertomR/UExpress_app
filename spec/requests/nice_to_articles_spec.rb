require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<request>nice_to_articles", type: :request do
  before do
    @user = FactoryBot.create(:user, :activated)
    @user_article = @user.articles.create(title: "First Example", accuracy_text: 1,
      difficultylevel_text: 1, articletext: "This app's first article!", Eschool_level: false,
      JHschool_level: true, Hschool_level: false)
    @another = FactoryBot.create(:user, :activated)
    @another_article = @another.articles.create(title: "Second Example", accuracy_text: 1,
      difficultylevel_text: 1, articletext: "This app's second article!", Eschool_level: false,
      JHschool_level: true, Hschool_level: false)
  end

  describe ":nice_to_articles/create_action" do
    context "if you do not login" do
      it "you don't change nice_to_article's count" do
        expect do
          post nice_to_articles_path, params: { article_id: @another_article.id }
        end.to change(NiceToArticle, :count).by(0)
      end
    end

    context "if you aren't author and you login" do
      it "you change nice_to_article's count" do
        log_in_as(@user)
        expect do
          post nice_to_articles_path, params: { article_id: @another_article.id }
        end.to change(NiceToArticle, :count).by(1)
      end
    end

    context "if you are author and you login" do
      it "Indeed, you can change nice_to_article's count" do
        log_in_as(@user)
        expect do
          post nice_to_articles_path, params: { article_id: @user_article.id }
        end.to change(NiceToArticle, :count).by(1)
      end
    end
  end

  describe ":nice_to_articles/destroy_action" do
    let!(:nice) { @user.nice_to_articles.create(article_id: @another_article.id) }

    context "if you do not login" do
      it "you can't decrease nice_to_article's count" do
        expect do
          delete nice_to_article_path(nice)
        end.to change(NiceToArticle, :count).by(0)
      end
    end

    context "if you login" do
      it "you can decrease nice_to_article's count by 1" do
        log_in_as(@user)
        expect do
          delete nice_to_article_path(nice)
        end.to change(NiceToArticle, :count).by(-1)
      end
    end
  end
end
