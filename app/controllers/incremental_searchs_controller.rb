class IncrementalSearchsController < ApplicationController
  def ajaxsearch
    # 全検索フォーム共通の処理
    if params[:question_or_article] == '記事'
      @match = Article.term(params[:term][0], params[:term][1])
                      .accuracy(params[:accuracy])
                      .difficulty(params[:difficulty])
                      .title(params[:word])
    else
      @match = Question.term(params[:term][0], params[:term][1])
                       .accuracy(params[:accuracy])
                       .difficulty(params[:difficulty])
                       .title(params[:word])
                       .solve?(params[:solve])
    end
    # 個人用検索フォーム専用の処理 // 空文字列でないならif文実行
    if params[:personalID] != ""
      @match = @match.who(params[:personalID])
    end
    render json: @match
  end
end
