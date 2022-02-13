class QuestionsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
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
  end

  def browsing
  end

  def edit
  end

  def update
  end

  def destroy
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
