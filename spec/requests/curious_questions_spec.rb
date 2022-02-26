require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<request>curious_questions", type: :request do
  before do
    @user = FactoryBot.create(:user, :activated)
    @user_question = @user.questions.create(title: "first Q", accuracy_text: 1,
      difficultylevel_text: 1, questiontext: "This app's first question!", Eschool_level: false,
      JHschool_level: true, Hschool_level: false, solve: false)
    @another = FactoryBot.create(:user, :activated)
    @another_question = @another.questions.create(title: "Second Q", accuracy_text: 1,
      difficultylevel_text: 1, questiontext: "This app's second question!", Eschool_level: false,
      JHschool_level: true, Hschool_level: false, solve: false)
  end

  describe ":curious_question/create_action" do
    context "if you do not login" do
      it "you don't change curious_question's count" do
        expect do
          post curious_questions_path, params: { question_id: @another_question.id }
        end.to change(CuriousQuestion, :count).by(0)
      end
    end

    context "if you aren't author and you login" do
      it "you change curious_question's count" do
        log_in_as(@user)
        expect do
          post curious_questions_path, params: { question_id: @another_question.id }
        end.to change(CuriousQuestion, :count).by(1)
      end
    end

    context "if you are author and you login" do
      it "Indeed, you can change nice_to_article's count" do
        log_in_as(@user)
        expect do
          post curious_questions_path, params: { question_id: @user_question.id }
        end.to change(CuriousQuestion, :count).by(1)
      end
    end
  end

  describe ":curious_questions/destroy_action" do
    let!(:curious) { @user.curious_questions.create(question_id: @another_question.id) }

    context "if you do not login" do
      it "you can't decrease curious_question's count" do
        expect do
          delete curious_question_path(curious)
        end.to change(CuriousQuestion, :count).by(0)
      end
    end

    context "if you login" do
      it "you can decrease curious_question's count by 1" do
        log_in_as(@user)
        expect do
          delete curious_question_path(curious)
        end.to change(CuriousQuestion, :count).by(-1)
      end
    end
  end
end
