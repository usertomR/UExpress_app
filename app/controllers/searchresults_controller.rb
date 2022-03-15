class SearchresultsController < ApplicationController
  def matched_articles
    @pagy, @articles = pagy(Article.term(params[:term_from], params[:term_to])
       .accuracy(params[:accuracy_select])
       .difficulty(params[:difficulty_select])
       .title(params[:content]))
  end

  def matched_questions
    @pagy, @questions = pagy(Question.term(params[:term_from], params[:term_to])
    .accuracy(params[:accuracy_select])
    .difficulty(params[:difficulty_select])
    .title(params[:content])
    .solve?(params[:solve]))
  end
end
