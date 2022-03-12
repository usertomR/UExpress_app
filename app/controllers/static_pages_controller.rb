class StaticPagesController < ApplicationController
  def home
    # 下記インスタンス変数は、検索フォームの種類(質問用 or 記事用)を判別する。
    if logged_in?
      @article_or_question = ApplicationRecord.root_search_form(params[:model])
      if @article_or_question.instance_of?(Article)
        @pagy, @articles = pagy(Article.all)
      else
        @pagy, @questions = pagy(Question.all)
      end
    end
  end

  def about
  end

  def contact
  end
end
