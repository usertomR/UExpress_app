class ArticlesController < ApplicationController
  def new
  end

  def show
    @user = User.find(params[:id])
    @articles = @user.articles
  end

  def index
  end
end
