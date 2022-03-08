require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<request>nice_to_answers", type: :request do
  before do
    @user = FactoryBot.create(:user, :activated)
    @user_question = @user.questions.create(title: "First Example", accuracy_text: 1,
      difficultylevel_text: 1, questiontext: "This app's first question!", Eschool_level: false,
      JHschool_level: true, Hschool_level: false, solve: false)
    @another = FactoryBot.create(:user, :activated)
    @another_question = @another.questions.create(title: "Second Example", accuracy_text: 1,
      difficultylevel_text: 1, questiontext: "This app's second question!", Eschool_level: false,
      JHschool_level: true, Hschool_level: false, solve: false)

    @user_answer = @another_question.answer_to_questions.create(user_id: @user.id, answer: "@user!")
    @another_answer = @user_question.answer_to_questions.create(user_id: @another.id, answer: "@another!")
  end

  context "if @user do not login" do
    it "application prompts @user to login" do
      post nice_to_answers_path, params: {
        answer_to_question_id: @another_answer.id,
        user_id: @user.id
      }
      expect(response).to redirect_to login_path
    end
  end

  describe ":nice_to_answers/create_action" do
    context "if @user logins and gives nice to @another_answer" do
      it "@user increases nice_to_answer's count by 1" do
        log_in_as(@user)
        expect do
          post nice_to_answers_path, params: {
            answer_to_question_id: @another_answer.id,
            user_id: @user.id
          }
        end.to change(NiceToAnswer, :count).by(1)
      end
    end

    # 質問への回答者が、自身が作ったその回答にniceをしてはいけないということ
    context "if @user logins and gives nice to @user_answer" do
      it "@user can't increase nice_to_answer's count" do
        log_in_as(@user)
        expect do
          post nice_to_answers_path, params: {
            answer_to_question_id: @user_answer.id,
            user_id: @user.id
          }
        end.to change(NiceToAnswer, :count).by(0)
      end
    end

    context "if @user logins and gives nice to @another_answer second time" do
      it "@user can't increases nice_to_answer's count and that raises an error" do
        @user_nice = NiceToAnswer.create!(user_id: @user.id, answer_to_question_id: @another_answer.id)
        log_in_as(@user)
        expect do
          post nice_to_answers_path, params: {
            answer_to_question_id: @another_answer.id,
            user_id: @user.id
          }
        end.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe ":nice_to_answers/destroy_action" do
    before do
      @user_nice = NiceToAnswer.create!(user_id: @user.id, answer_to_question_id: @another_answer.id)
      @another_nice = NiceToAnswer.create!(user_id: @another.id, answer_to_question_id: @user_answer.id)
    end

    context "if @user logins and delete @user's [nice]" do
      it "@user can delete" do
        log_in_as(@user)
        expect do
          delete nice_to_answer_path(@user_nice), params: { question_id: @user_question.id }
        end.to change(NiceToAnswer, :count).by(-1)
      end
    end

    context "if @user logins and delete @another's [nice]" do
      it "@user can't delete" do
        log_in_as(@user)
        expect do
          delete nice_to_answer_path(@another_nice), params: { question_id: @another_question.id }
        end.to change(NiceToAnswer, :count).by(0)
      end
    end
  end
end
