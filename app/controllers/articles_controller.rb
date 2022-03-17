class ArticlesController < ApplicationController
  # before_actionにbrowsingがあるのは、ログイン(テストログイン含む)しないでアクセスするとエラーが発生するから。
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :browsing]
  before_action :correct_user, only: [:destroy, :edit, :update]

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

  # 検索フォームを使わずに当アクションにアクセスしたら、個人の記事全てを表示。
  # 検索フォームで検索または検索後のページネーションボタンを使うと、該当する記事のみ表示する仕様
  def show
    @user = User.find(params[:id])
    if params[:use_form] != "true"
      @pagy, @articles = pagy(@user.articles)
    else
      @matched_articles = @user.articles.term(params[:term_from], params[:term_to])
                               .accuracy(params[:accuracy_select])
                               .difficulty(params[:difficulty_select])
                               .title(params[:content])
      @pagy, @articles = pagy(@matched_articles)
    end
  end

  def browsing
    @article = Article.find(params[:id])
  end

  # before_actionで,@articleを取得している。(update,destroyも)
  def edit
  end

  def update
    if @article.update(article_params)
      flash[:success] = "記事更新完了!"
      redirect_to browsing_article_path(@article)
    else
      render 'edit'
    end
  end

  def destroy
    @article.destroy
    flash[:success] = "1つの記事を削除しました。"
    redirect_to request.referrer || root_url
  end

  private

  def article_params
    params.require(:article).permit(:title, :accuracy_text, :difficultylevel_text,
                  :articletext, :Eschool_level, :JHschool_level, :Hschool_level)
  end

  def correct_user
    @article = current_user.articles.find_by(id: params[:id])
    redirect_to root_url if @article.nil?
  end
end
