require 'rails_helper'

RSpec.describe CuriousQuestion, type: :model do
  describe ":validation" do
    before do
      @user = FactoryBot.create(:user, :activated)
      @another = FactoryBot.create(:user, :activated)

      @another_question = @another.questions.create(title: "Second Q", accuracy_text: 1,
        difficultylevel_text: 1, questiontext: "This app's second question!", Eschool_level: false,
        JHschool_level: true, Hschool_level: false, solve: false)

      @curious = @another.curious_questions.create(question_id: @another_question.id)
    end

    it "is valid" do
      expect(@curious).to be_valid
    end

    it "is invaild without user_id" do
      @curious.user_id = nil
      expect(@curious).not_to be_valid
    end

    it "is invaild without question_id" do
      @curious.question_id = nil
      expect(@curious).to be_invalid
    end
  end
end
