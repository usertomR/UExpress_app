require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<system>Questions", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    @user = FactoryBot.create(:user, :activated)
  end

  describe ":When you create a question" do
    context "it is invalid" do
      it "because you write worng infomation" do
        login_as(@user)
        visit new_question_path
        fill_in '質問タイトル', with: '   '
        execute_script('window.scrollBy(0,10000)')
        sleep 0.2
        click_on '質問作成'
        aggregate_failures do
          expect(current_path).to eq questions_path
          expect(page).to have_content 'The form contains 5 errors'
          expect(page).to have_content 'タイトル:空欄にしないで下さい'
          expect(page).to have_content '文章の正しさ:1つ選択して下さい'
          expect(page).to have_content '文章難易度:1つ選択して下さい'
          expect(page).to have_content '対象:1つ以上選んで下さい'
          expect(page).to have_content '質問本体:空欄にしないで下さい'
        end
      end

      it "because you don't log in(already activated)" do
        visit new_question_path
        expect(page).to have_content 'ログインして下さい'
      end
    end

    context "it is vaild" do
      it "because you write right infomation" do
        login_as(@user)
        visit new_question_path
        fill_in '質問タイトル', with: "Test"
        choose 'question_accuracy_text_4'
        choose 'question_difficultylevel_text_3'
        check 'question_JHschool_level'
        fill_in_rich_text_area 'question_questiontext', with: "Test"
        click_on '質問作成'
        expect(current_path).to eq root_path
        expect(page).to have_content '質問を作成しました'
      end
    end
  end

  describe ":When you edit a question", js: true do
    before do
      # 記事を作成しておく(作者:@user)
      login_as(@user)
      visit new_question_path
      fill_in '質問タイトル', with: "Test"
      choose 'question_accuracy_text_4'
      choose 'question_difficultylevel_text_3'
      check 'question_JHschool_level'
      fill_in_rich_text_area 'question_questiontext', with: "Test"
      click_on '質問作成'
      # 記事作成ここまで
      @another = FactoryBot.create(:user, :activated)
    end

    context "you can't edit" do
      it "because you are not an author" do
        system_spec_log_out
        login_as(@another)
        visit("questions/#{@user.id}")
        expect(page).not_to have_content '編集'
      end

      it "because you don't log in(already activated and article writer)" do
        system_spec_log_out
        @question = Question.where("title LIKE ?", "Test")
        visit("/articles/#{@question[0].id}/edit")
        expect(current_path).to eq login_path
      end
    end

    context "you can edit" do
      # デフォルトでは、「未解決」が選択さている
      it "because you are an author" do
        @question = Question.where("title LIKE ?", "Test")
        visit("/questions/#{@question[0].id}/edit")
        fill_in '質問タイトル', with: "Test again!"
        choose 'question_accuracy_text_3'
        choose 'question_difficultylevel_text_5'
        check 'question_Hschool_level'
        fill_in_rich_text_area 'question_questiontext', with: "RSpec!"
        click_on '質問更新'
        expect(page).to have_content '質問更新完了!'
        get question_path(@user)
        expect(page.body).to have_content '未解決'
      end
    end

    context "you choose 「解決」" do
      it "So, browser display 「解決」" do
        @question = Question.where("title LIKE ?", "Test")
        visit("/questions/#{@question[0].id}/edit")
        fill_in '質問タイトル', with: "Test again!"
        choose 'question_accuracy_text_3'
        choose 'question_difficultylevel_text_5'
        choose 'question_solve_true'
        check 'question_Hschool_level'
        fill_in_rich_text_area 'question_questiontext', with: "RSpec!"
        click_on '質問更新'
        expect(page).to have_content '質問更新完了!'
        get question_path(@user)
        expect(page.body).to have_content '解決'
      end
    end
  end

  describe ":When you delete a question", js: true do
    before do
      # 記事を作成しておく(作者:@user)
      login_as(@user)
      visit new_question_path
      fill_in '質問タイトル', with: "Test"
      choose 'question_accuracy_text_4'
      choose 'question_difficultylevel_text_3'
      check 'question_JHschool_level'
      fill_in_rich_text_area 'question_questiontext', with: "Test"
      click_on '質問作成'
      # 記事作成ここまで
      @another = FactoryBot.create(:user, :activated)
    end
    context "you can't delete" do
      it "because you have no right to delete" do
        system_spec_log_out
        login_as(@another)
        visit("questions/#{@user.id}")
        expect(page).not_to have_content '削除'
      end
    end

    context "you can delete" do
      it "because you are the question's writer" do
        login_as(@user)
        visit("questions/#{@user.id}")
        expect do
          accept_alert do
            click_on '削除'
          end
          # sleep使わないと失敗する。ちょっと待とう。
          sleep(0.5)
        end.to change(Question, :count).by(-1)
      end
    end
  end
end
