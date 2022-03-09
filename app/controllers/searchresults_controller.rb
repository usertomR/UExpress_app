class SearchresultsController < ApplicationController
  def result
  end

  def personalarticle
    @user = User.find(params[:id])
    @pagy, @articles = pagy(Article.term(params[:term_from], params[:term_to])
       .accuracy(params[:accuracy_select])
       .difficulty(params[:difficulty_select])
       .title(params[:content])
       .who(params[:id]))
  end

  def personalquestion
    @user = User.find(params[:id])
    @pagy, @questions = pagy(Question.term(params[:term_from], params[:term_to])
    .accuracy(params[:accuracy_select])
    .difficulty(params[:difficulty_select])
    .title(params[:content])
    .who(params[:id])
    .solve?(params[:solve]))
  end
end
