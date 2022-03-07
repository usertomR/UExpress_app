class NiceToArticleCommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @comment = ArticleComment.find(params[:article_comment_id])
    @nice_comment = @comment.nice_to_article_comments.create(user_id: params[:user_id])
    @article = Article.find(params[:article_id])
    redirect_to browsing_article_path(@article)
  end

  def destroy
    @nice_comment = NiceToArticleComment.find(params[:id])
    @article = Article.find(params[:article_id])
    @nice_comment.destroy
    redirect_to browsing_article_path(@article)
  end
end
