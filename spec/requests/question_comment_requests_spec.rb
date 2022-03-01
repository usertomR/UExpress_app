require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<request>question_comments", type: :request do
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

  describe ":question_comments/create_action" do
    context "if you do not login" do
      it "you don't change question_comment's count" do
        expect do
          post question_comments_path, params: { question_comment: {
            user_id: @user.id.to_s,
            question_id: @another_question.id.to_s,
            comment: "Test"
          } }
        end.to change(QuestionComment, :count).by(0)
      end
    end

    context "if you aren't author and you login" do
      it "you can't change question_comment's count" do
        log_in_as(@user)
        expect do
          post question_comments_path, params: { question_comment: {
            user_id: @another.id.to_s,
            question_id: @another_question.id.to_s,
            comment: "Test"
          } }
        end.to change(QuestionComment, :count).by(0)
      end
    end

    context "if you are author and you login" do
      it "you can change question_comment's count with comment" do
        log_in_as(@user)
        expect do
          post question_comments_path, params: { question_comment: {
            user_id: @user.id.to_s,
            question_id: @another_question.id.to_s,
            comment: "Test"
          } }
        end.to change(QuestionComment, :count).by(1)
      end

      it "you can't change question_comment's count with no comment" do
        log_in_as(@user)
        expect do
          post question_comments_path, params: { question_comment: {
            user_id: @user.id.to_s,
            question_id: @another_question.id.to_s,
            comment: "   "
          } }
        end.to change(QuestionComment, :count).by(0)
      end
    end
  end

  describe ":question_comments/destroy_action" do
    let!(:comment) { @user.question_comments.create(user_id: @user.id, question_id: @another_question.id, comment: "RSpec test!") }

    context "if you do not login" do
      it "you can't decrease question_comment's count" do
        expect do
          delete question_comment_path(comment)
        end.to change(QuestionComment, :count).by(0)
      end
    end

    context "if you login and you are not writer" do
      it "you can't decrease question_comment's count" do
        log_in_as(@another)
        expect do
          delete question_comment_path(comment)
        end.to change(QuestionComment, :count).by(0)
      end
    end

    context "if you login and you are a writer" do
      it "you can decrease question_comment's count by 1" do
        log_in_as(@user)
        expect do
          delete question_comment_path(comment)
        end.to change(QuestionComment, :count).by(-1)
      end
    end
  end
end
