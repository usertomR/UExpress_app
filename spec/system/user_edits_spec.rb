require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<system>UserEdit", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    @user = FactoryBot.create(:user, :activated)
    login_as(@user)
    visit edit_user_path(@user)
  end

  # it "don't have the string-アカウント更新-" do
  #   expect(page).not_to have_content '仮アカウント更新'
  # end

  it "succeeds edit with correct information" do
    fill_in '名前', with: @user.name
    fill_in 'Email', with: @user.email
    fill_in 'パスワード', with: @user.password
    fill_in 'パスワード確認', with: @user.password
    fill_in '自己紹介', with: 'Test'
    click_on 'アカウント更新'
    aggregate_failures do
      expect(current_path).to eq user_path(@user)
    end
  end

  it "fails edit with wrong information" do
    fill_in '名前', with: ''
    fill_in 'Email', with: ''
    fill_in 'パスワード', with: ''
    fill_in 'パスワード確認', with: ''
    fill_in '自己紹介', with: 'Test'
    click_on 'アカウント更新'
    aggregate_failures do
      expect(current_path).to eq user_path(@user)
    end
  end
end
