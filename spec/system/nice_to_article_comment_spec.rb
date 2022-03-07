require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<system>nice_to_article_comment", type: :system do
  before do
    driven_by(:selenium_chrome_headless)

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

  context "if you don't login" do
    it "you can't push good button(can't access browsing_article_path)" do
      visit browsing_article_path(@another_article)
      expect(current_path).to eq login_path
    end
  end

  describe ":nice_to_article_comment/create_action" do
    context "if @user login and @user want to push good button to @user's comment" do
      it "@user can't push" do
        login_as(@user)
        visit browsing_article_path(@another_article)
        expect(page).to have_text 'good計'
      end
    end

    context "if @user login and @user want to push good button to other's comment" do
      it "@user can push" do
        # @anotherの記事に対し、@anotherがコメントする
        @another_comment = @another_article.article_comments.create(user_id: @another.id, comment: "Test")
        login_as(@user)
        visit browsing_article_path(@another_article)
        within(".changeable_button") do
          click_on 'good'
        end
        sleep 0.5
        expect(@user.nice_to_article_comments.count).to eq 1
      end
    end
  end

  describe ":nice_to_article_comment/destroy_action" do
    context "if @user login and @user want to delete other's [good]" do
      it "@user can delete" do
        login_as(@user)
        visit browsing_article_path(@another_article)
        expect(page).to have_text 'good計'
      end
    end

    context "if @user login and @user want to delete my [good]" do
      it "@user can delete" do
        @another_comment = @another_article.article_comments.create(user_id: @another.id, comment: "Test")
        # @anotherが作ったコメントに対し、@userがgoodボタンを押した
        @user.nice_to_article_comments.create(article_comment_id: @another_comment.id)
        login_as(@user)
        visit browsing_article_path(@another_article)
        within(".changeable_button") do
          click_on 'good'
        end
        sleep 0.5
        expect(@user.nice_to_article_comments.count).to eq 0
      end
    end
  end
end
