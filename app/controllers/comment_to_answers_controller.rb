class CommentToAnswersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_destroy, only: [:destroy]
  before_action :correct_create, only: [:create]

  def create
    answer_id_array_index = params[:comment_to_answer][:answer_id].to_i - 1
    # rubyでは、配列の[]内の数値はマイナスでも良い。そうだと、回答する対象が変わる可能性があるため、if文使用
    if answer_id_array_index >= 1
      answer_to_question_id = params[:comment_to_answer][:answer_id_array].split(' ')[answer_id_array_index].to_i
    end
    @question = Question.find(params[:question_id])
    @answer = AnswerToQuestion.find_by(id: answer_to_question_id)
    @comment = @answer && @answer.comment_to_answers.build(user_id: params[:comment_to_answer][:user_id],
                answer_to_question_id: answer_to_question_id, comment: params[:comment_to_answer][:comment])

    if @comment && @comment.save
      flash[:info] = "コメントを作成しました"
    else
      # unlessの条件式を満たさない場合、flash[:danger]の文章を上書きする
      flash[:danger] = "コメント作成失敗"
      unless 1 <= answer_id_array_index && answer_id_array_index <= params[:comment_to_answer][:answer_id_array].split(' ').count
        flash[:danger] = "適切な番号を入力して下さい"
      end
    end
    redirect_to browsing_question_path(@question)
  end

  def destroy
    @question = @comment.answer_to_question.question
    @comment.destroy
    flash[:info] = "コメントを削除しました"
    redirect_to browsing_question_path(@question)
  end

  private

  def comment_params
    params.require(:comment_to_answer).permit(:user_id, :answer_to_question_id, :comment)
  end

  # 「ある人」が、その「ある人」でない他の人のふりをして投稿できると困る。
  def correct_create
    unless params[:comment_to_answer][:user_id] == current_user.id.to_s
      redirect_to root_path
    end
  end

  def correct_destroy
    @comment = current_user.comment_to_answers.find_by(id: params[:id])
    redirect_to root_url if @comment.nil?
  end
end
