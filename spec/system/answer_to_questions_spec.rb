require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<system>AnswerToQuestion", type: :system do
  before do
    driven_by(:selenium_chrome_headless)

    @user = FactoryBot.create(:user, :activated)
    @user_question = @user.questions.create(title: "First Example", accuracy_text: 1,
      difficultylevel_text: 1, questiontext: "This app's first question!", Eschool_level: false,
      JHschool_level: true, Hschool_level: false, solve: false)
    @another = FactoryBot.create(:user, :activated)
    @another_question = @another.questions.create(title: "Second Example", accuracy_text: 1,
      difficultylevel_text: 1, questiontext: "This app's second question!", Eschool_level: false,
      JHschool_level: true, Hschool_level: false, solve: false)
  end

  describe ":answer_to_questions/create_action", js: true do
    context "if @user login" do
      context "and @user answer to a question," do
        it "generated AnswerToQuestion record's user_id is equal to @user.id" do
          login_as(@user)
          visit browsing_question_path(@user_question)
          execute_script('window.scrollBy(0,10000)')
          sleep 0.5
          fill_in_rich_text_area 'answer_to_question_answer', with: "Test"
          click_on '回答'
          expect(@user.answer_to_questions[0].user_id).to eq @user.id
        end
      end

      context "and @user don't answer to a question," do
        it "@user can't increase AnswerToQuestion's count" do
          login_as(@user)
          visit browsing_question_path(@user_question)
          execute_script('window.scrollBy(0,10000)')
          sleep 0.5
          expect do
            fill_in_rich_text_area 'answer_to_question_answer', with: "      "
            click_on '回答'
            sleep 0.5
          end.to change(AnswerToQuestion, :count).by(0)
        end
      end
    end

    context "if @user do not login" do
      it "@user visits login page" do
        visit browsing_question_path(@another_question)
        expect(current_path).to eq login_path
      end
    end
  end

  describe ":answer_to_questions/destroy_action", js: true do
    context "if @user do not login" do
      it "@user visits login page" do
        visit browsing_question_path(@another_question)
        expect(current_path).to eq login_path
      end
    end

    context "if @user login" do
      context "and @user are question's author," do
        it "@user can push a button for deleting a answer" do
          @answer = @user.answer_to_questions.create(user_id: @user.id,
            question_id: @another_question.id, answer: "RSpec test!")
          login_as(@user)
          visit browsing_question_path(@another_question)
          expect do
            accept_alert do
              click_on '削除'
            end
            sleep 0.5
          end.to change(AnswerToQuestion, :count).by(-1)
        end
      end

      context "and @user are not question's author," do
        it "@user can't push a button for deleting a comment" do
          @another_answer = @another.answer_to_questions.create(user_id: @another.id,
            question_id: @another_question.id, answer: "RSpec test!")
          login_as(@user)
          visit browsing_question_path(@another_question)
          execute_script('window.scrollBy(0,10000)')
          sleep 0.5
          expect(page).not_to have_content '削除'
        end
      end
    end
  end
end
