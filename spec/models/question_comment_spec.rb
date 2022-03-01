require 'rails_helper'

RSpec.describe "<model>AnswerToQuestion", type: :model do
  describe ":validation" do
    before do
      @user = FactoryBot.create(:user, :activated)

      @another = FactoryBot.create(:user, :activated)
      @another_question = @another.questions.create(title: "Second Example", accuracy_text: 1,
        difficultylevel_text: 1, questiontext: "This app's second question!", Eschool_level: false,
        JHschool_level: true, Hschool_level: false, solve: false)

      @comment = @another_question.answer_to_questions.create(user_id: @user.id, comment: "Test")
    end

    it "is valid" do
      expect(@comment).to be_valid
    end

    it "is invaild without user_id" do
      @comment.user_id = nil
      expect(@comment).not_to be_valid
    end

    it "is invaild without question_id" do
      @comment.question_id = nil
      expect(@comment).to be_invalid
    end

    it "is invaild without comment" do
      @comment.comment = nil
      expect(@comment).to be_invalid
    end
  end
end
