require 'rails_helper'

RSpec.describe "<model>AnswerToQuestion", type: :model do
  describe ":validation" do
    before do
      @user = FactoryBot.create(:user, :activated)

      @another = FactoryBot.create(:user, :activated)
      @another_question = @another.questions.create(title: "Second Example", accuracy_text: 1,
        difficultylevel_text: 1, questiontext: "This app's second question!", Eschool_level: false,
        JHschool_level: true, Hschool_level: false, solve: false)

      @answer = @another_question.answer_to_questions.create(user_id: @user.id, answer: "Test")
    end

    it "is valid" do
      expect(@answer).to be_valid
    end

    it "is invaild without user_id" do
      @answer.user_id = nil
      expect(@answer).not_to be_valid
    end

    it "is invaild without question_id" do
      @answer.question_id = nil
      expect(@answer).to be_invalid
    end

    it "is invaild without answer" do
      @answer.answer = nil
      expect(@answer).to be_invalid
    end
  end
end
