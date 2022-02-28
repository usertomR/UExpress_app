class ArticleCommentsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_destroy, only: [:destroy]
  before_action :correct_create, only: [:create]

  # updateがないのは、コメントのやり取りがおかしくなる可能性があるから。
  # コメントを修正したいならもう一度コメントを作って追記する形にすると、話の流れがおかしくならない
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
    @article = @comment.article
    @comment.destroy
    flash[:info] = "コメントを削除しました"
    redirect_to browsing_article_path(@article)
  end

  private

  def comment_params
    params.require(:article_comment).permit(:user_id, :article_id, :comment)
  end

  def correct_destroy
    @comment = current_user.article_comments.find_by(id: params[:id])
    redirect_to root_url if @comment.nil?
  end

  # 「ある人」が、その「ある人」でない他の人のふりをして投稿できると困る。
  def correct_create
    unless params[:article_comment][:user_id] == current_user.id.to_s
      redirect_to root_path
    end
  end
end
