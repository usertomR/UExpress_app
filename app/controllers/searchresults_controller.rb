class SearchresultsController < ApplicationController
  def result
  end

  def personalarticle
    @user = User.find(params[:id])
    @pagy, @articles = pagy(Article.term(params[:term_from], params[:term_to])
       .accuracy(params[:accuracy_select])
       .difficulty(params[:difficulty_select])
       .title(params[:content]))
  end

  def personalquestion
    @user = User.find(params[:id])
    @pagy, @questions = pagy(Question.where("updated_at >= :start_date AND updated_at <= :end_date",
      { start_date: params[:term_from], end_date: params[:term_to] })
       .where(accuracy_text: params[:accuracy_select])
       .where(difficultylevel_text: params[:difficulty_select])
       .where("title LIKE ?", '%' + params[:content] + '%')
       .where(solve: params[:solve]))
  end
end
