class QuestionsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :browsing]
  before_action :correct_user, only: [:destroy, :edit, :update]

  def new
    @question = current_user.questions.build if logged_in?
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash[:info] = "質問を作成しました"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @pagy, @questions = pagy(@user.questions)
  end

  def browsing
    @question = Question.find(params[:id])
  end

  # before_actionで,@questionを取得している。(update,destroyも)
  def edit
  end

  def update
    if @question.update(question_params)
      flash[:success] = "質問更新完了!"
      redirect_to browsing_question_path(@question)
    else
      render 'edit'
    end
  end

  def destroy
    @question.destroy
    flash[:success] = "1つの質問を削除しました。"
    redirect_to root_url
  end

  private

  def question_params
    params.require(:question).permit(:title, :accuracy_text, :difficultylevel_text,
                  :questiontext, :Eschool_level, :JHschool_level, :Hschool_level, :solve)
  end

  def correct_user
    @question = current_user.questions.find_by(id: params[:id])
    redirect_to root_url if @question.nil?
  end
end
