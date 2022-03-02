require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<system>question_bookmark", type: :system do
  before do
    driven_by(:selenium_chrome_headless)

    @user = FactoryBot.create(:user, :activated)
    @user_question = @user.questions.build(title: "first Q", accuracy_text: 1,
      difficultylevel_text: 1, questiontext: "This app's first question!", Eschool_level: false,
      JHschool_level: true, Hschool_level: false, solve: false)
    @another = FactoryBot.create(:user, :activated)
    @another_question = @another.questions.build(title: "Second Q", accuracy_text: 1,
      difficultylevel_text: 1, questiontext: "This app's second question!", Eschool_level: false,
      JHschool_level: true, Hschool_level: false, solve: false)
  end

  describe ":question_bookmarks/create_action" do
    before do
      @user_question.save
      @another_question.save
    end

    context "if @user login and question is not solved" do
      context "and @user are question's author," do
        it "@user can push bookmark button to the question" do
          login_as(@user)
          visit browsing_question_path(@user_question)
          expect do
            click_on 'bookmark'
            sleep 0.5
          end.to change(QuestionBookmark, :count).by(1)
        end
      end

      context "and @user are not question's author," do
        it "@user can push bookmark button to the question" do
          login_as(@user)
          visit browsing_question_path(@another_question)
          within(".questionbookmark_button") do
            click_on 'bookmark'
          end
          sleep 0.5
          expect(@user.sum_questionbookmark_per_user[0]).to eq @another_question
        end
      end
    end

    context "if @user login and question is solved" do
      before do
        login_as(@user)
        @user_question.solve = true
        @another_question.solve = true
        @user_question.save
        @another_question.save
      end

      context "and @user are question's author," do
        it "@user push bookmark button to the question" do
          visit browsing_question_path(@user_question)
          expect do
            click_on 'bookmark'
            sleep 0.5
          end.to change(QuestionBookmark, :count).by(1)
        end
      end

      context "and @user are not question's author," do
        it "@user can push bookmark button to the question" do
          login_as(@user)
          visit browsing_question_path(@another_question)
          expect do
            click_on 'bookmark'
            sleep 0.5
          end.to change(QuestionBookmark, :count).by(1)
        end
      end
    end

    context "if @user do not login" do
      it "@user visits login page" do
        visit browsing_question_path(@another_question)
        expect(current_path).to eq login_path
      end
    end
  end

  describe ":question_bookmarks/destroy_action" do
    before do
      @user_question.save
      @another_question.save
      @user.question_bookmarks.create(question_id: @another_question.id)
    end

    context "if @user do not login" do
      it "@user visits login page" do
        visit browsing_question_path(@another_question)
        expect(current_path).to eq login_path
      end
    end

    context "if @user login and question is not solved" do
      context "and @user are question's author," do
        context "and  visits /questions/:id/browsing" do
          it "@user can push bookmark button to the question" do
            @user.question_bookmarks.create(question_id: @user_question.id)
            login_as(@user)
            visit browsing_question_path(@user_question)
            expect do
              click_on 'bookmark'
              sleep 0.5
            end.to change(QuestionBookmark, :count).by(-1)
          end
        end

        context "and visits /user/:id/questionbookmark" do
          it "@user can push [ブックマーク取り消し] button to the question" do
            login_as(@user)
            visit user_questionbookmark_path(@user)
            expect do
              click_on 'ブックマーク取り消し'
              sleep 0.5
            end.to change(QuestionBookmark, :count).by(-1)
          end
        end
      end

      context "and @user are not question's author," do
        context "and  visits /questions/:id/browsing" do
          it "@user can push bookmark button to the question" do
            login_as(@user)
            visit browsing_question_path(@another_question)
            within(".questionbookmark_button") do
              click_on 'bookmark'
            end
            sleep 0.5
            expect(@user.sum_questionbookmark_per_user.count).to eq 0
          end
        end

        context "and visits /user/:id/questionbookmark" do
          it "@user can push 「bookmark取り消し」 button to the question" do
            login_as(@user)
            visit user_questionbookmark_path(@user)
            expect do
              click_on 'ブックマーク取り消し'
              sleep 0.5
            end.to change(QuestionBookmark, :count).by(-1)
          end
        end
      end
    end
  end
end
