class NiceToAnswersController < ApplicationController
  before_action :logged_in_user

  def create
    @answer = AnswerToQuestion.find(params[:answer_to_question_id])
    @answer.nice_to_answers.create(user_id: params[:user_id])
    @question = @answer.question
    redirect_to browsing_question_path(@question)
  end

  def destroy
    @nice_answer = NiceToAnswer.find(params[:id])
    @question = Question.find(params[:question_id])
    @nice_answer.destroy
    redirect_to browsing_question_path(@question)
  end
end
