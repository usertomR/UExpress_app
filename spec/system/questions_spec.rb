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
end
