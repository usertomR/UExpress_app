require 'rails_helper'

RSpec.describe NiceToArticleComment, type: :model do
  describe ":validation" do
    before do
      @user = FactoryBot.create(:user, :activated)
      @another = FactoryBot.create(:user, :activated)

      # @anotherが記事を一つ作る
      @another_article = @another.articles.create(title: "Second Example", accuracy_text: 1,
        difficultylevel_text: 1, articletext: "This app's second article!", Eschool_level: false,
        JHschool_level: true, Hschool_level: false)

      # @anotherの記事に対し、@userがコメントする
      @comment = @another_article.article_comments.create(user_id: @user.id, comment: "Test")

      # 仮に@nice_comment.saveすると,上記の@userのコメントに対し、@anotherが「いいね」をすることになる
      @nice_comment = @comment.nice_to_article_comments.build(user_id: @another.id)
    end

    it "is valid" do
      expect(@nice_comment).to be_valid
    end

    it "is invaild without user_id" do
      @nice_comment.user_id = nil
      expect(@nice_comment).not_to be_valid
    end

    it "is invaild without article_comment_id" do
      @nice_comment.article_comment_id = nil
      expect(@nice_comment).to be_invalid
    end
  end
end
