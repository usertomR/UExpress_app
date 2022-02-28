require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<request>article_comments", type: :request do
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

  describe ":article_comments/create_action" do
    context "if you do not login" do
      it "you don't change article_comment's count" do
        expect do
          post article_comments_path, params: { article_comment: {
            user_id: @user.id.to_s,
            article_id: @another_article.id.to_s,
            comment: "Test"
          } }
        end.to change(ArticleComment, :count).by(0)
      end
    end

    context "if you aren't author and you login" do
      it "you can't change article_comment's count" do
        log_in_as(@user)
        expect do
          post article_comments_path, params: { article_comment: {
            user_id: @another.id.to_s,
            article_id: @another_article.id.to_s,
            comment: "Test"
          } }
        end.to change(ArticleComment, :count).by(0)
      end
    end

    context "if you are author and you login" do
      it "you can change article_comment's count with comment" do
        log_in_as(@user)
        expect do
          post article_comments_path, params: { article_comment: {
            user_id: @user.id.to_s,
            article_id: @another_article.id.to_s,
            comment: "Test"
          } }
        end.to change(ArticleComment, :count).by(1)
      end

      it "you can't change article_comment's count with no comment" do
        log_in_as(@user)
        expect do
          post article_comments_path, params: { article_comment: {
            user_id: @user.id.to_s,
            article_id: @another_article.id.to_s,
            comment: "   "
          } }
        end.to change(ArticleComment, :count).by(0)
      end
    end
  end

  describe ":article_comments/destroy_action" do
    let!(:comment) { @user.article_comments.create(user_id: @user.id, article_id: @another_article.id, comment: "RSpec test!") }

    context "if you do not login" do
      it "you can't decrease article_comment's count" do
        expect do
          delete article_comment_path(comment)
        end.to change(ArticleComment, :count).by(0)
      end
    end

    context "if you login and you are not writer" do
      it "you can't decrease article_comment's count" do
        log_in_as(@another)
        expect do
          delete article_comment_path(comment)
        end.to change(ArticleComment, :count).by(0)
      end
    end

    context "if you login and you are a writer" do
      it "you can decrease article_comment's count by 1" do
        log_in_as(@user)
        expect do
          delete article_comment_path(comment)
        end.to change(ArticleComment, :count).by(-1)
      end
    end
  end
end
