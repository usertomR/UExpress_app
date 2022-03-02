require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<request>answer_to_questions", type: :request do
  before do
    @user = FactoryBot.create(:user, :activated)
    @user_question = @user.questions.create(title: "First Example", accuracy_text: 1,
      difficultylevel_text: 1, questiontext: "This app's first question!", Eschool_level: false,
      JHschool_level: true, Hschool_level: false, solve: false)
    @another = FactoryBot.create(:user, :activated)
    @another_question = @another.questions.create(title: "Second Example", accuracy_text: 1,
      difficultylevel_text: 1, questiontext: "This app's second question!", Eschool_level: false,
      JHschool_level: true, Hschool_level: false, solve: false)
  end

  describe ":answer_to_questions/create_action" do
    context "if you do not login" do
      it "you don't change answer_to_question's count" do
        expect do
          post answer_to_questions_path, params: { answer_to_question: {
            user_id: @user.id.to_s,
            question_id: @another_question.id.to_s,
            answer: "Test"
          } }
        end.to change(AnswerToQuestion, :count).by(0)
      end
    end

    context "if you aren't author and you login" do
      it "you can't change answer_to_question's count" do
        log_in_as(@user)
        expect do
          post answer_to_questions_path, params: { answer_to_question: {
            user_id: @another.id.to_s,
            question_id: @another_question.id.to_s,
            answer: "Test"
          } }
        end.to change(AnswerToQuestion, :count).by(0)
      end
    end

    context "if you are author and you login" do
      it "you can change answer_to_question's count with answer" do
        log_in_as(@user)
        expect do
          post answer_to_questions_path, params: { answer_to_question: {
            user_id: @user.id.to_s,
            question_id: @another_question.id.to_s,
            answer: "Test"
          } }
        end.to change(AnswerToQuestion, :count).by(1)
      end

      it "you can't change answer_to_question's count with no answer" do
        log_in_as(@user)
        expect do
          post answer_to_questions_path, params: { answer_to_question: {
            user_id: @user.id.to_s,
            question_id: @another_question.id.to_s,
            answer: "   "
          } }
        end.to change(AnswerToQuestion, :count).by(0)
      end
    end
  end

  describe ":answer_to_questions/destroy_action" do
    let!(:answer) { @user.answer_to_questions.create(user_id: @user.id, question_id: @another_question.id, answer: "RSpec test!") }

    context "if you do not login" do
      it "you can't decrease answer_to_question's count" do
        expect do
          delete answer_to_question_path(answer)
        end.to change(AnswerToQuestion, :count).by(0)
      end
    end

    context "if you login and you are not writer" do
      it "you can't decrease answer_to_question's count" do
        log_in_as(@another)
        expect do
          delete answer_to_question_path(answer)
        end.to change(AnswerToQuestion, :count).by(0)
      end
    end

    context "if you login and you are a writer" do
      it "you can decrease answer_to_question's count by 1" do
        log_in_as(@user)
        expect do
          delete answer_to_question_path(answer)
        end.to change(AnswerToQuestion, :count).by(-1)
      end
    end
  end
end
