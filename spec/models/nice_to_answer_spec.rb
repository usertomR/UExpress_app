require 'rails_helper'

RSpec.describe "<model>NiceToAnswer", type: :model do
  describe ":validation" do
    before do
      @user = FactoryBot.create(:user, :activated)

      @another = FactoryBot.create(:user, :activated)
      @another_question = @another.questions.create(title: "Second Example", accuracy_text: 1,
        difficultylevel_text: 1, questiontext: "This app's second question!", Eschool_level: false,
        JHschool_level: true, Hschool_level: false, solve: false)

      @answer = @another_question.answer_to_questions.create(user_id: @user.id, answer: "Test")
      @nice_answer = @answer.nice_to_answers.create(user_id: @another.id)
    end

    it "is valid" do
      expect(@nice_answer).to be_valid
    end

    it "is invalid without user_id" do
      @nice_answer.user_id = nil
      expect(@nice_answer).not_to be_valid
    end

    it "is invalid without answer_to_question_id" do
      @nice_answer.answer_to_question_id = nil
      expect(@nice_answer).not_to be_valid
    end
  end
end
