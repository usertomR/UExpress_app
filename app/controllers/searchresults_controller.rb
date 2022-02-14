class SearchresultsController < ApplicationController
  def result
  end

  def personalarticle
    @user = User.find(params[:id])
    @pagy, @articles = pagy(Article.where("updated_at >= :start_date AND updated_at <= :end_date",
      { start_date: params[:term_from], end_date: params[:term_to] })
       .where(accuracy_text: params[:accuracy_select])
       .where(difficultylevel_text: params[:difficulty_select])
       .where("title LIKE ?", '%' + params[:content] + '%'))
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
