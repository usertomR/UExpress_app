class ArticleCommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @article = Article.find(params[:article_comment][:article_id])
    @comment = @article.article_comments.build(comment_params)
    if @comment.save
      flash[:info] = "コメントを作成しました"
    else
      flash[:danger] = "コメント作成失敗"
    end
    redirect_to browsing_article_path(@article)
  end

  def destroy
  end

  private

  def comment_params
    params.require(:article_comment).permit(:user_id, :article_id, :comment)
  end
end
