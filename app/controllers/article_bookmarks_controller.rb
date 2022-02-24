class ArticleBookmarksController < ApplicationController
  before_action :logged_in_user

  def create
    @article = Article.find(params[:article_id])
    current_user.sum_bookmark_per_user << @article
    respond_to do |format|
      format.html { redirect_to browsing_article_path(@article) }
      format.js
    end
  end

  def destroy
    @article = ArticleBookmark.find(params[:id]).article
    current_user.article_bookmarks.find_by(article_id: @article.id).destroy
    respond_to do |format|
      format.html { redirect_to browsing_article_path(@article) }
      format.js
    end
  end
end
