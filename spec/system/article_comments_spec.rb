require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<system>ArticleComment", type: :system do
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
  end

  describe ":article_comments/create_action", js: true do
    context "if @user login" do
      context "and @user make  a comment to an article," do
        it "generated ArticleComment record's user_id is equal to @user.id" do
          login_as(@user)
          visit browsing_article_path(@user_article)
          execute_script('window.scrollBy(0,10000)')
          sleep 0.2
          fill_in_rich_text_area 'article_comment_comment', with: "Test"
          click_on 'コメント投稿'
          expect(@user.article_comments[0].user_id).to eq @user.id
        end
      end

      context "and @user don't make a comment to an article," do
        it "@user can't increase ArticleComment's count by 1" do
          login_as(@user)
          visit browsing_article_path(@user_article)
          execute_script('window.scrollBy(0,10000)')
          sleep 0.3
          expect do
            fill_in_rich_text_area 'article_comment_comment', with: "      "
            click_on 'コメント投稿'
            sleep 0.3
          end.to change(ArticleComment, :count).by(0)
        end
      end
    end

    context "if @user do not login" do
      it "@user visits login page" do
        visit browsing_article_path(@another_article)
        expect(current_path).to eq login_path
      end
    end
  end

  describe ":article_comments/destroy_action" do
    context "if @user do not login" do
      it "@user visits login page" do
        visit browsing_article_path(@another_article)
        expect(current_path).to eq login_path
      end
    end

    context "if @user login" do
      context "and @user are article's author," do
        it "@user can push a button for deleting a comment" do
          @comment = @user.article_comments.create(user_id: @user.id,
                article_id: @another_article.id, comment: "RSpec test!")
          login_as(@user)
          visit browsing_article_path(@another_article)
          execute_script('window.scrollBy(0,10000)')
          sleep 0.5
          expect do
            accept_alert do
              click_on '削除'
            end
            sleep 0.3
          end.to change(ArticleComment, :count).by(-1)
        end
      end

      context "and @user are not article's author," do
        it "@user can't push a button for deleting a comment" do
          @another_comment = @another.article_comments.create(user_id: @another.id,
                article_id: @another_article.id, comment: "RSpec test!")
          login_as(@user)
          visit browsing_article_path(@another_article)
          execute_script('window.scrollBy(0,10000)')
          sleep 0.3
          expect(page).not_to have_content '削除'
        end
      end
    end
  end
end
