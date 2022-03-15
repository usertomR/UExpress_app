class StaticPagesController < ApplicationController
  def home
    # @article_or_questionは、検索フォームの種類(質問用 or 記事用)を判別する。
    if logged_in?
      @article_or_question = ApplicationRecord.root_search_form(params[:model])
      if @article_or_question.instance_of?(Article)
        if params[:use_form] != "true"
          @pagy, @articles = pagy(Article.all)
        else
          @matched_articles = Article.term(params[:term_from], params[:term_to])
                                     .accuracy(params[:accuracy_select])
                                     .difficulty(params[:difficulty_select])
                                     .title(params[:content])
          @pagy, @articles = pagy(@matched_articles)
        end
      else
        if params[:use_form] != "true"
          @pagy, @questions = pagy(Question.all)
        else
          @matched_questions = Question.term(params[:term_from], params[:term_to])
                                       .accuracy(params[:accuracy_select])
                                       .difficulty(params[:difficulty_select])
                                       .title(params[:content])
                                       .solve?(params[:solve])
          @pagy, @questions = pagy(@matched_questions)
        end
      end
    end
  end

  def about
  end

  def contact
  end
end
