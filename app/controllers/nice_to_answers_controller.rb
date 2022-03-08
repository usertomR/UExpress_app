class NiceToAnswersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_create, only: [:create]
  before_action :correct_destroy, only: [:destroy]

  def create
    @answer.nice_to_answers.create(user_id: params[:user_id])
    @question = @answer.question
    redirect_to browsing_question_path(@question)
  end

  def destroy
    @question = Question.find(params[:question_id])
    @nice_answer.destroy
    redirect_to browsing_question_path(@question)
  end

  private

  def correct_create
    @answer = AnswerToQuestion.find(params[:answer_to_question_id])
    if @answer.user_id == params[:user_id].to_i
      flash[:danger] = "自身の回答にniceボタンを押さないでください"
      redirect_to root_path
    end
  end

  def correct_destroy
    @nice_answer = NiceToAnswer.find(params[:id])
    if @nice_answer.user_id != current_user.id
      flash[:danger] = "他人のniceを勝手に消さないでください"
      redirect_to root_path
    end
  end
end
