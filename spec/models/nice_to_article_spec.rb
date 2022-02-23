require 'rails_helper'

RSpec.describe "<model>Nice_to_articles", type: :model do
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

      @nice = @user.nice_to_articles.create(article_id: @another_article.id)
    end

    it "is valid" do
      expect(@nice).to be_valid
    end

    it "is invaild without user_id" do
      @nice.user_id = nil
      expect(@nice).not_to be_valid
    end

    it "is invaild without article_id" do
      @nice.article_id = nil
      expect(@nice).to be_invalid
    end
  end
end
