require 'rails_helper'

RSpec.describe "<model>CommentToAnswer", type: :model do
  before do
    @user = FactoryBot.create(:user, :activated)
    @another = FactoryBot.create(:user, :activated)
    @question = FactoryBot.create(:question)
    @answer = AnswerToQuestion.create(user_id: @another.id, question_id: @question.id,
                              answer: "RSpec")
    @comment = @answer.comment_to_answers.build(user_id: @user.id, comment: "yeah! RSpec")
  end

  describe ":validation" do
    it "is valid with 2 ids and comment" do
      expect(@comment).to be_valid
    end

    it "is invalid without answer_to_question_id" do
      @comment.answer_to_question_id = nil
      expect(@comment).to be_invalid
    end

    it "is invalid without user_id" do
      @comment.user_id = nil
      expect(@comment).to be_invalid
    end

    it "is invalid without comment" do
      @comment.comment = "   "
      expect(@comment).to be_invalid
    end
  end
end
