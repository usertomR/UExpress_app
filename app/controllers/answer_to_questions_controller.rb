class AnswerToQuestionsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_destroy, only: [:destroy]
  before_action :correct_create, only: [:create]

  # updateがないのは、コメントのやり取りがおかしくなる可能性があるから。
  # コメントを修正したいならもう一度コメントを作って追記する形にすると、話の流れがおかしくならない
  def create
    @question = Question.find(params[:answer_to_question][:question_id])
    @answer = @question.answer_to_questions.build(comment_params)
    if @answer.save
      flash[:info] = "回答を作成しました"
    else
      flash[:danger] = "回答作成失敗"
    end
    redirect_to browsing_question_path(@question)
  end

  def destroy
    @question = @answer.question
    @answer.destroy
    flash[:info] = "回答を削除しました"
    redirect_to browsing_question_path(@question)
  end

  private

  def comment_params
    params.require(:answer_to_question).permit(:user_id, :question_id, :answer)
  end

  def correct_destroy
    @answer = current_user.answer_to_questions.find_by(id: params[:id])
    redirect_to root_url if @answer.nil?
  end

  # 「ある人」が、その「ある人」でない他の人のふりをして投稿できると困る。
  def correct_create
    unless params[:answer_to_question][:user_id] == current_user.id.to_s
      redirect_to root_path
    end
  end
end
