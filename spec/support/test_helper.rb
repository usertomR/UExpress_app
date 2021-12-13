# RSpecで使いたいメソッドなどをかく。使うファイルでは、include・requireを忘れずに。
def is_logged_in?
  !session[:user_id].nil?
end

# RequestSpec用
def log_in_as(user, remember_me: '1')
  post login_path, params: { session: {
    email: user.email,
    password: user.password,
    remember_me: remember_me
  } }
end

# SystemSpec用
def login_as(user)
  visit login_path
  fill_in 'Email', with: user.email
  fill_in 'パスワード', with: user.password
  click_button 'ログイン'
end
