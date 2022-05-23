class Spa::Backend::HelloworldsController < ApplicationController
  def show
    # user_state・・・ログインしているか、管理者(ログイン前提)かどうかなどの情報
    user_state = { login: "", login_and_admin: "", user: "" }
    # ログインしているかどうかの判別
    if logged_in?
      user_state[:login] = "true"
    else
      user_state[:login] = "false"
    end
    # ログインしている管理者かどうかを判別する
    if current_user && current_user.admin?
      user_state[:login_and_admin] = "true"
    else
      user_state[:login_and_admin] = "false"
    end
    # ユーザーの情報を得る
    user_state[:user] = current_user

    render json: user_state
  end
end
