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

# 使用する際は,js:trueを指定すること
def system_spec_log_out
  find(".header_btn").click
  click_link('ログアウト')
end

def fill_in_rich_text_area(locator = nil, with:)
  find(:rich_text_area, locator).execute_script("this.editor.loadHTML(arguments[0])", with.to_s)
end
# これがないとfill_in_rich_text_areaメソッドがエラーを起こす.
Capybara.add_selector :rich_text_area do
  label "rich-text area"
  xpath do |locator|
    if locator.nil?
      XPath.descendant(:"trix-editor")
    else
      input_located_by_name = XPath.anywhere(:input).where(XPath.attr(:name) == locator).attr(:id)

      XPath.descendant(:"trix-editor").where \
        XPath.attr(:id).equals(locator) |
        XPath.attr(:placeholder).equals(locator) |
        XPath.attr(:"aria-label").equals(locator) |
        XPath.attr(:input).equals(input_located_by_name)
    end
  end
end
