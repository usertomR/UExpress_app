require 'rails_helper'

RSpec.describe "<model>ArticleComment", type: :model do
  describe ":validation" do
    before do
      @user = FactoryBot.create(:user, :activated)

      @another = FactoryBot.create(:user, :activated)
      @another_article = @another.articles.create(title: "Second Example", accuracy_text: 1,
        difficultylevel_text: 1, articletext: "This app's second article!", Eschool_level: false,
        JHschool_level: true, Hschool_level: false)

      @comment = @another_article.article_comments.build(user_id: @user.id, comment: "Test")
    end

    it "is valid" do
      expect(@comment).to be_valid
    end

    it "is invaild without user_id" do
      @comment.user_id = nil
      expect(@comment).not_to be_valid
    end

    it "is invaild without article_id" do
      @comment.article_id = nil
      expect(@comment).to be_invalid
    end

    it "is invaild without comment" do
      @comment.comment = nil
      expect(@comment).to be_invalid
    end
  end
end
