class QuestionBookmarksController < ApplicationController
  before_action :logged_in_user

  def create
    @question = Question.find(params[:question_id])
    current_user.sum_questionbookmark_per_user << @question
    respond_to do |format|
      format.html { redirect_to browsing_question_path(@question) }
      format.js
    end
  end

  def destroy
    @question = QuestionBookmark.find(params[:id]).question
    current_user.question_bookmarks.find_by(question_id: @question.id).destroy
    if (params[:not_ajax] == "true")
      redirect_to user_questionbookmark_path(current_user)
    else
      respond_to do |format|
        format.html { redirect_to browsing_question_path(@question) }
        format.js
      end
    end
  end
end
