require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<system>nice_to_article", type: :system do
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

  describe ":nice_to_articles/create_action" do
    context "if @user login" do
      context "and @user are article's author," do
        it "@user can't push nice button to the article" do
          login_as(@user)
          visit browsing_article_path(@user_article)
          expect(page).to have_text 'nice計'
        end
      end

      context "and @user are not article's author," do
        it "@user can push nice button to the article" do
          login_as(@user)
          visit browsing_article_path(@another_article)
          within(".nice_button") do
            click_on 'nice'
          end
          sleep 0.5
          expect(@user.sum_nice_per_user[0]).to eq @another_article
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

  describe ":nice_to_articles/destroy_action" do
    context "if @user do not login" do
      it "@user visits login page" do
        visit browsing_article_path(@another_article)
        expect(current_path).to eq login_path
      end
    end

    context "if @user login" do
      context "and @user are article's author," do
        context "and  visits /articles/:id/browsing" do
          it "@user can't push nice button to the article" do
            login_as(@user)
            visit browsing_article_path(@user_article)
            expect(page).to have_text 'nice計'
          end
        end

        context "and visits /user/:id/nice" do
          it "@user can push 「nice取り消し」 button to the article" do
            login_as(@user)
            @user.nice_to_articles.create(article_id: @user_article.id)
            visit user_nice_path(@user)
            expect(page).to have_button 'nice取り消し'
          end
        end
      end

      context "and @user are not article's author," do
        context "and  visits /articles/:id/browsing" do
          it "@user can push nice button to the article" do
            login_as(@user)
            @user.nice_to_articles.create(article_id: @another_article.id)
            visit browsing_article_path(@another_article)
            within(".nice_button") do
              click_on 'nice'
            end
            sleep 0.5
            expect(@user.sum_nice_per_user.count).to eq 0
          end
        end

        context "and visits /user/:id/nice" do
          it "@user can push 「nice取り消し」 button to the article" do
            login_as(@user)
            @user.nice_to_articles.create(article_id: @another_article.id)
            visit user_nice_path(@user)
            expect(page).to have_button 'nice取り消し'
          end
        end
      end
    end
  end
end
