class QuestionCommentsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_destroy, only: [:destroy]
  before_action :correct_create, only: [:create]

  # updateがないのは、コメントのやり取りがおかしくなる可能性があるから。
  # コメントを修正したいならもう一度コメントを作って追記する形にすると、話の流れがおかしくならない
  def create
    @question = Question.find(params[:question_comment][:question_id])
    @comment = @question.question_comments.build(comment_params)
    if @comment.save
      flash[:info] = "コメントを作成しました"
    else
      flash[:danger] = "コメント作成失敗"
    end
    redirect_to browsing_question_path(@question)
  end

  def destroy
    @question = @comment.question
    @comment.destroy
    flash[:info] = "コメントを削除しました"
    redirect_to browsing_question_path(@question)
  end

  private

  def comment_params
    params.require(:question_comment).permit(:user_id, :question_id, :comment)
  end

  def correct_destroy
    @comment = current_user.question_comments.find_by(id: params[:id])
    redirect_to root_url if @comment.nil?
  end

  # 「ある人」が、その「ある人」でない他の人のふりをして投稿できると困る。
  def correct_create
    unless params[:question_comment][:user_id] == current_user.id.to_s
      redirect_to root_path
    end
  end
end
