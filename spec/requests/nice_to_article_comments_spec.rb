require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<request>nice_to_article_comments", type: :request do
  before do
    @user = FactoryBot.create(:user, :activated)
    @user_article = @user.articles.create(title: "First Example", accuracy_text: 1,
      difficultylevel_text: 1, articletext: "This app's first article!", Eschool_level: false,
      JHschool_level: true, Hschool_level: false)
    @another = FactoryBot.create(:user, :activated)
    @another_article = @another.articles.create(title: "Second Example", accuracy_text: 1,
      difficultylevel_text: 1, articletext: "This app's second article!", Eschool_level: false,
      JHschool_level: true, Hschool_level: false)

    # @anotherの記事に対し、@userがコメントする
    @comment = @another_article.article_comments.create(user_id: @user.id, comment: "Test")
  end

  describe ":nice_to_article_comments/create_action" do
    context "if @another don't login" do
      it "@another can't change nice_to_article_comment's count" do
        expect do
          post nice_to_article_comments_path, params: { user_id: @another.id, article_id: @another_article.id,
                                                      article_comment_id: @comment.id }
        end.to change(NiceToArticleComment, :count).by(0)
      end
    end

    context "if @another login and sends [nice] to @user's comment" do
      it "@another increases nice_to_article_comment's count by 1" do
        expect do
          log_in_as(@another)
          post nice_to_article_comments_path, params: { user_id: @another.id, article_id: @another_article.id,
                                                      article_comment_id: @comment.id }
        end.to change(NiceToArticleComment, :count).by(1)
      end
    end
  end

  describe ":nice_to_article_comments/destroy_action" do
    context "if @another don't login" do
      it "@another can't change nice_to_article_comment's count" do
        # 上記の@userのコメントに対し、@anotherが[good]を与える
        @nice_comment = @comment.nice_to_article_comments.create!(user_id: @another.id)
        expect do
          # 引数に何か(この例では@nice_comment)を指定してかつparamsも指定できるが、なぜ？同時利用不可能と思っていた。
          delete nice_to_article_comment_path(@nice_comment), params: { article_id: @another_article.id }
        end.to change(NiceToArticleComment, :count).by(0)
      end
    end

    context "if @another login and delete [good] to @user's comment" do
      it "@another decreases nice_to_article_comment's count by 1" do
        @nice_comment = @comment.nice_to_article_comments.create!(user_id: @another.id)
        expect do
          log_in_as(@another)
          delete nice_to_article_comment_path(@nice_comment), params: { article_id: @another_article.id }
        end.to change(NiceToArticleComment, :count).by(-1)
      end
    end
  end
end
