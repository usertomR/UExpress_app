class ApplicationController < ActionController::Base
  include SessionsHelper
  # ページネーションpagyを使用するのに必要な記述。別にここで書く必要はない
  include Pagy::Backend

  # ユーザーのログインを確認する
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
end
