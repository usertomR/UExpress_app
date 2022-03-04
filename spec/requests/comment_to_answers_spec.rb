require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<request>comment_to_answers", type: :request do
  before do
    @user = FactoryBot.create(:user, :activated)
    @another = FactoryBot.create(:user, :activated)
    @question = FactoryBot.create(:question)
    @answer = AnswerToQuestion.create(user_id: @another.id, question_id: @question.id,
                              answer: "RSpec")
    @another_answer = AnswerToQuestion.create(user_id: @user.id, question_id: @question.id,
                              answer: "rails")
  end

  describe ":comment_to_answers/create_action" do
    context "if you don't login" do
      it "you don't make a comment" do
        expect do
          post comment_to_answers_path, params: {
            question_id: @question.id,
            comment_to_answer: {
              answer_id_array: @answer.id.to_s,
              answer_id: 1,
              user_id: @user.id,
              comment: "fail!"
            }
          }
        end.to change(CommentToAnswer, :count).by(0)
      end
    end

    context "if @user login" do
      # 回答を2つ作っています。ここでは、1番・2番以外は不適切な番号となります。
      it "and @user  specify wrong number of answer, @user can't make a comment(number 3)" do
        expect do
          log_in_as(@user)
          post comment_to_answers_path, params: {
            comment_to_answer: {
              answer_id_array: @answer.id.to_s,
              answer_id: "3",
              user_id: @user.id.to_s,
              comment: "fail!"
            },
            question_id: @question.id.to_s
          }
        end.to change(CommentToAnswer, :count).by(0)
      end

      it "and @user  specify wrong number of answer, @user can't make a comment(number 0)" do
        expect do
          log_in_as(@user)
          post comment_to_answers_path, params: {
            comment_to_answer: {
              answer_id_array: @answer.id.to_s,
              answer_id: "0",
              user_id: @user.id.to_s,
              comment: "fail!"
            },
            question_id: @question.id.to_s
          }
        end.to change(CommentToAnswer, :count).by(0)
      end

      it "and @user don't write comment text, @user can't make a comment" do
        expect do
          log_in_as(@user)
          post comment_to_answers_path, params: {
            comment_to_answer: {
              answer_id_array: @answer.id.to_s,
              answer_id: "1",
              user_id: @user.id.to_s,
              comment: " "
            },
            question_id: @question.id.to_s
          }
        end.to change(CommentToAnswer, :count).by(0)
      end

      it "and @user make a comment as @another, @user can't make a comment" do
        expect do
          log_in_as(@user)
          post comment_to_answers_path, params: {
            comment_to_answer: {
              answer_id_array: @answer.id.to_s,
              answer_id: "1",
              user_id: @another.id.to_s,
              comment: "なりすまし"
            },
            question_id: @question.id.to_s
          }
        end.to change(CommentToAnswer, :count).by(0)
      end

      it "and @user inputs appropriate infomation, @user can make a comment" do
        expect do
          log_in_as(@user)
          post comment_to_answers_path, params: {
            comment_to_answer: {
              answer_id_array: @answer.id.to_s,
              answer_id: "1",
              user_id: @user.id.to_s,
              comment: "fail!"
            },
            question_id: @question.id.to_s
          }
        end.to change(CommentToAnswer, :count).by(1)
      end
    end
  end

  describe ":comment_to_answers/destroy_action" do
    before do
      @comment = @user.comment_to_answers.create(answer_to_question_id: @answer.id, comment: "test")
    end

    context "if @user don't login" do
      it "@user can't delete a comment" do
        expect do
          delete comment_to_answer_path(@comment)
        end.to change(CommentToAnswer, :count).by(0)
      end
    end

    context "if @user login" do
      it "and @user tries to delete comment of @another, @user can't delete a comment" do
        @another_comment = @another.comment_to_answers.create(answer_to_question_id: @another_answer.id,
                                                              comment: "test")

        log_in_as(@user)
        expect do
          delete comment_to_answer_path(@another_comment)
        end.to change(CommentToAnswer, :count).by(0)
      end

      it "and @user tries to delete comment of @user, @user can delete a comment" do
        log_in_as(@user)
        expect do
          delete comment_to_answer_path(@comment)
        end.to change(CommentToAnswer, :count).by(-1)
      end
    end
  end
end
