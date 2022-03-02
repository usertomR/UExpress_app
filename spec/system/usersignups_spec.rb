require 'rails_helper'

RSpec.describe "<system>UserSignups", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  it "don't create new data when user submits invalid information", js: true do
    visit signup_path
    fill_in '名前', with: ' '
    fill_in 'Email', with: 'user@invalid'
    fill_in 'パスワード', with: 'foo'
    fill_in 'パスワード確認', with: 'bar'
    fill_in '自己紹介', with: 'Test'
    execute_script('window.scrollBy(0,10000)')
    sleep 0.5
    click_on 'アカウント作成'
    aggregate_failures do
      expect(current_path).to eq users_path
      expect(page).to have_content 'Signup'
      expect(page).to have_content 'The form contains 4 errors'
    end
  end

  it "create new data when user submits valid information", js: true do
    visit signup_path
    fill_in '名前', with: 'Example User'
    fill_in 'Email', with: 'user@example.com'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード確認', with: 'password'
    fill_in '自己紹介', with: 'Test'
    execute_script('window.scrollBy(0,10000)')
    sleep 0.5
    click_on 'アカウント作成'
    aggregate_failures do
      expect(current_path).to eq root_path
      expect(page).to have_content "登録したemailを確認しよう!"
    end
  end
end
