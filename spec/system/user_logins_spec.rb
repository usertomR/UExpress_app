require 'rails_helper'

RSpec.describe "<system>UserLogins", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    @user = FactoryBot.create(:user, :activated)
  end

  it "don't login when user submits invalid information" do
    visit login_path
    fill_in 'Email', with: ' '
    fill_in 'パスワード', with: ' '
    click_button 'ログイン'
    aggregate_failures do
      expect(current_path).to eq login_path
      expect(page).to have_content 'どちらかまたは両方の入力を間違えています'
    end
  end

  it "login succeeds when user submits valid information" do
    visit login_path
    fill_in 'Email', with: @user.email
    fill_in 'パスワード', with: @user.password
    click_button 'ログイン'
    aggregate_failures do
      expect(current_path).to eq user_path(@user)
      expect(page).to have_link 'ログアウト', href: logout_path
      expect(page).to have_link 'アカウント更新', href: edit_user_path(@user)
    end

    click_on 'ログアウト'
    aggregate_failures do
      expect(current_path).to eq root_path
      expect(page).to have_no_link 'ログアウト'
      expect(page).to have_no_link 'アカウント更新'
    end
  end
end
