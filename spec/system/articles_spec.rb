require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<system>Articles", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    @user = FactoryBot.create(:user, :activated)
  end

  describe ":When you create an article", js: true do
    context "it is invalid" do
      it "because you write worng infomation" do
        login_as(@user)
        visit new_article_path
        fill_in '記事タイトル', with: '   '
        execute_script('window.scrollBy(0,10000)')
        sleep 0.5
        click_on '記事作成'
        aggregate_failures do
          expect(current_path).to eq articles_path
          expect(page).to have_content 'The form contains 5 errors'
          expect(page).to have_content 'タイトル:空欄にしないで下さい'
          expect(page).to have_content '文章の正しさ:1つ選択して下さい'
          expect(page).to have_content '読みやすさ:1つ選択して下さい'
          expect(page).to have_content '対象:1つ以上選んで下さい'
          expect(page).to have_content '記事本体:空欄にしないで下さい'
        end
      end

      it "because you don't log in(already activated)" do
        visit new_article_path
        expect(page).to have_content 'ログインして下さい'
      end
    end

    context "it is vaild" do
      it "because you write right infomation" do
        login_as(@user)
        visit new_article_path
        fill_in '記事タイトル', with: "Test"
        choose 'article_accuracy_text_4'
        choose 'article_difficultylevel_text_3'
        check 'article_JHschool_level'
        fill_in_rich_text_area 'article_articletext', with: "Test"
        click_on '記事作成'
        expect(current_path).to eq root_path
        expect(page).to have_content '記事を作成しました'
      end
    end
  end

  describe ":When you edit an article", js: true do
    before do
      # 記事を作成しておく(作者:@user)
      login_as(@user)
      visit new_article_path
      fill_in '記事タイトル', with: "Test"
      choose 'article_accuracy_text_4'
      choose 'article_difficultylevel_text_3'
      check 'article_JHschool_level'
      fill_in_rich_text_area 'article_articletext', with: "Test"
      click_on '記事作成'
      # 記事作成ここまで
      @another = FactoryBot.create(:user, :activated)
    end

    context "you can't edit" do
      it "because you are not an author" do
        system_spec_log_out
        login_as(@another)
        visit("articles/#{@user.id}")
        expect(page).not_to have_content '編集'
      end

      it "because you don't log in(already activated && article writer)" do
        system_spec_log_out
        @article = Article.where("title LIKE ?", "Test")
        visit("/articles/#{@article[0].id}/edit")
        expect(current_path).to eq login_path
      end
    end

    context "you can edit" do
      it "because you are an author" do
        @article = Article.where("title LIKE ?", "Test")
        visit("/articles/#{@article[0].id}/edit")
        fill_in '記事タイトル', with: "Test again!"
        choose 'article_accuracy_text_3'
        choose 'article_difficultylevel_text_5'
        check 'article_Hschool_level'
        fill_in_rich_text_area 'article_articletext', with: "RSpec!"
        click_on '記事更新'
        expect(page).to have_content '記事更新完了!'
      end
    end
  end

  describe ":When you delete an article", js: true do
    before do
      # 記事を作成しておく(作者:@user)
      login_as(@user)
      visit new_article_path
      fill_in '記事タイトル', with: "Test"
      choose 'article_accuracy_text_4'
      choose 'article_difficultylevel_text_3'
      check 'article_JHschool_level'
      fill_in_rich_text_area 'article_articletext', with: "Test"
      click_on '記事作成'
      # 記事作成ここまで
      @another = FactoryBot.create(:user, :activated)
    end
    context "you can't delete" do
      it "because you have no right to delete" do
        system_spec_log_out
        login_as(@another)
        visit("articles/#{@user.id}")
        expect(page).not_to have_content '削除'
      end
    end

    context "you can delete" do
      it "because you are the article's writer" do
        login_as(@user)
        visit("articles/#{@user.id}")
        expect do
          accept_alert do
            click_on '削除'
          end
          # sleep使わないと失敗する。ちょっと待とう。
          sleep(0.5)
        end.to change(Article, :count).by(-1)
      end
    end
  end
end
