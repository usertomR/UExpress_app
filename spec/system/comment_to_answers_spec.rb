require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<system>CommentToAnswer", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    @user = FactoryBot.create(:user, :activated)
    @another = FactoryBot.create(:user, :activated)
    @question = FactoryBot.create(:question)
    @answer = AnswerToQuestion.create(user_id: @another.id, question_id: @question.id,
                                        answer: "RSpec")
  end

  describe ":comment_to_answers/create_action", js: true do
    context "if @user don't login" do
      it "@user can't access browsing page(of caurse, can't make a comment)" do
        visit browsing_question_path(@question)
        expect(current_path).to eq login_path
      end
    end

    context "if @user login and access a browsing page" do
      before do
        @another_answer = AnswerToQuestion.create(user_id: @user.id, question_id: @question.id,
          answer: "ruby")
        login_as(@user)
        visit browsing_question_path(@question)
        execute_script('window.scrollBy(0,10000)')
        sleep 0.5
      end

      it "and click a submit button without a number of answer, can't make a comment" do
        fill_in_rich_text_area 'comment_to_answer_comment', with: "aaaaaa"
        click_on "コメント投稿"
        expect(page).to have_content '適切な番号を入力して下さい'
      end

      # 回答が2つ作成されているので、1番・2番以外は不適切な値となります
      it "and click a submit button without a number of answer, can't make a comment" do
        fill_in 'comment_to_answer_answer_id', with: "3"
        fill_in_rich_text_area 'comment_to_answer_comment', with: "aaaaaa"
        click_on "コメント投稿"
        expect(page).to have_content '適切な番号を入力して下さい'
      end

      it "and click a submit button without a number of answer, can't make a comment" do
        fill_in 'comment_to_answer_answer_id', with: "0"
        fill_in_rich_text_area 'comment_to_answer_comment', with: "aaaaaa"
        click_on "コメント投稿"
        expect(page).to have_content '適切な番号を入力して下さい'
      end

      it "and click a submit button without comment text , can't make a comment" do
        fill_in 'comment_to_answer_answer_id', with: "1"
        click_on "コメント投稿"
        expect(page).to have_content 'コメント作成失敗'
      end

      it "and click a submit button with appropriate infomation, @user can make a comment(ver 1)" do
        fill_in 'comment_to_answer_answer_id', with: "1"
        fill_in_rich_text_area 'comment_to_answer_comment', with: "aaaaaa"
        click_on "コメント投稿"
        expect(page).to have_content 'コメントを作成しました'
      end

      # なぜか1つ目の回答以外にはコメントできなかったので、とりあえずテスト
      it "and click a submit button with appropriate infomation, @user can make a comment(ver 2)" do
        fill_in 'comment_to_answer_answer_id', with: "2"
        fill_in_rich_text_area 'comment_to_answer_comment', with: "aaaaaa"
        click_on "コメント投稿"
        expect(page).to have_content 'コメントを作成しました'
      end
    end
  end

  describe ":comment_to_answers/destroy_action", js: true do
    context "if @user do not login" do
      it "@user can't access browsing page(of caurse, can't delete a comment)" do
        visit browsing_question_path(@question)
        expect(current_path).to eq login_path
      end
    end

    context "if @user login" do
      before do
        @comment = @user.comment_to_answers.create(answer_to_question_id: @answer.id, comment: "@user!")
        login_as(@user)
        visit browsing_question_path(@question)
        execute_script('window.scrollBy(0,500)')
        sleep 0.5
      end

      context "and @user tries to delete @user's comment" do
        it "@user can delete the comment" do
          expect do
            accept_alert do
              click_on '削除'
            end
            sleep 0.5
          end.to change(CommentToAnswer, :count).by(-1)
        end
      end
    end
  end
end
