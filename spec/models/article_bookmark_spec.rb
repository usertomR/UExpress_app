require 'rails_helper'

RSpec.describe ArticleBookmark, type: :model do
  describe ":validation" do
    before do
      @user = FactoryBot.create(:user, :activated)
      @user_article = @user.articles.create(title: "First Example", accuracy_text: 1,
        difficultylevel_text: 1, articletext: "This app's first article!", Eschool_level: false,
        JHschool_level: true, Hschool_level: false)

      @another = FactoryBot.create(:user, :activated)
      @another_article = @another.articles.create(title: "Second Example", accuracy_text: 1,
        difficultylevel_text: 1, articletext: "This app's second article!", Eschool_level: false,
        JHschool_level: true, Hschool_level: false)

      @bookmark = @user.article_bookmarks.create(article_id: @another_article.id)
    end

    it "is valid" do
      expect(@bookmark).to be_valid
    end

    it "is invaild without user_id" do
      @bookmark.user_id = nil
      expect(@bookmark).not_to be_valid
    end

    it "is invaild without article_id" do
      @bookmark.article_id = nil
      expect(@bookmark).to be_invalid
    end
  end
end
