require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<system>NiceToAnswer", type: :system do
  before do
    driven_by(:selenium_chrome_headless)

    @user = FactoryBot.create(:user, :activated)
    @user_question = @user.questions.create(title: "First Example", accuracy_text: 1,
      difficultylevel_text: 1, questiontext: "This app's first question!", Eschool_level: false,
      JHschool_level: true, Hschool_level: false, solve: false)
    @another = FactoryBot.create(:user, :activated)
    @another_question = @another.questions.create(title: "Second Example", accuracy_text: 1,
      difficultylevel_text: 1, questiontext: "This app's second question!", Eschool_level: false,
      JHschool_level: true, Hschool_level: false, solve: false)

    @user_answer = @another_question.answer_to_questions.create(user_id: @user.id, answer: "Test")
    @another_answer = @user_question.answer_to_questions.create(user_id: @another.id, answer: "Test")
  end

  context "if @user does not login" do
    it "@user can't access browsing_question_path page" do
      visit browsing_question_path(@another_question)
      expect(current_path).to eq login_path
    end
  end

  describe ":cerate_action" do
    context "if @user logins and push [nice] button for @another's answer" do
      it "@user incereases NiceToAnswer's count by 1" do
        login_as(@user)
        visit browsing_question_path(@user_question)
        execute_script('window.scrollBy(0,500)')
        sleep 0.5
        click_on 'nice'
        sleep 0.5
        within("#sum_nice") do
          expect(page).to have_text "1"
        end
      end
    end

    context "if @user logins and wants to push [nice] button for @user's answer" do
      it "@user can't incerease NiceToAnswer's count" do
        login_as(@user)
        visit browsing_question_path(@another_question)
        execute_script('window.scrollBy(0,500)')
        sleep 0.5
        expect(page).to have_text "nice計"
      end
    end
  end

  describe ":destroy_action" do
    before do
      @user_nice_answer = @another_answer.nice_to_answers.create(user_id: @user.id)
      @another_nice_answer = @user_answer.nice_to_answers.create(user_id: @another.id)
    end

    context "if @user logins and push [nice] button for @another's answer" do
      it "@user decereases NiceToAnswer's count by 1" do
        login_as(@user)
        visit browsing_question_path(@user_question)
        execute_script('window.scrollBy(0,500)')
        sleep 0.5
        click_on 'nice'
        sleep 0.5
        within("#sum_nice") do
          expect(page).to have_text "0"
        end
      end
    end

    context "if @user logins and wants to push [nice] button for @user's answer" do
      it "@user can't decerease NiceToAnswer's count" do
        login_as(@user)
        visit browsing_question_path(@another_question)
        execute_script('window.scrollBy(0,500)')
        sleep 0.5
        expect(page).to have_text "nice計"
      end
    end
  end
end
