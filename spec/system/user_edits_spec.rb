require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<system>UserEdit", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    @user = FactoryBot.create(:user, :activated)
    login_as(@user)
    visit edit_user_path(@user)
  end

  it "succeeds edit with correct information", js: true do
    fill_in '名前', with: @user.name
    fill_in 'Email', with: @user.email
    fill_in 'パスワード', with: @user.password
    fill_in 'パスワード確認', with: @user.password
    fill_in '自己紹介', with: 'Test'
    # execute.. : https://www.selenium.dev/selenium/docs/api/rb/Selenium/WebDriver/Driver.html#execute_script-instance_method
    # jsを動かす。 : https://qiita.com/jnchito/items/c7e6e7abf83598a6516d#js-true%E3%81%AE%E3%81%A8%E3%81%8D%E3%81%A0%E3%81%91chrome%E3%82%92%E8%B5%B7%E5%8B%95%E3%81%99%E3%82%8B
    # jsを確実に実行: https://qiita.com/eitches/items/eee0d0502ee65feb6fa2#%E8%AA%BF%E3%81%B9%E3%81%9F%E3%82%BE%E3%82%A4
    execute_script('window.scrollBy(0,10000)')
    sleep 0.5
    click_on 'アカウント更新'
    aggregate_failures do
      expect(current_path).to eq user_path(@user)
    end
  end

  it "fails edit with wrong information", js: true do
    fill_in '名前', with: ''
    fill_in 'Email', with: ''
    fill_in 'パスワード', with: ''
    fill_in 'パスワード確認', with: ''
    fill_in '自己紹介', with: 'Test'
    execute_script('window.scrollBy(0,10000)')
    sleep 0.5
    click_on 'アカウント更新'
    aggregate_failures do
      expect(current_path).to eq user_path(@user)
    end
  end
end
