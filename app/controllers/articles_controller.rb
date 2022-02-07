class ArticlesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    @article = current_user.articles.build if logged_in?
  end

  def create
    # チェックボックスのデフォルトは、チェック付けたならtrue,そうでないならfalseらしい。
    # http://www.code-magagine.com/?p=12484
    @article = current_user.articles.build(article_params)
    if @article.save
      flash[:info] = "記事を作成しました"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @pagy, @articles = pagy(@user.articles)
  end

  def index
  end

  def browsing
    @article = Article.find(params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def article_params
    params.require(:article).permit(:title, :accuracy_text, :difficultylevel_text,
                  :articletext, :Eschool_level, :JHschool_level, :Hschool_level)
  end
end
