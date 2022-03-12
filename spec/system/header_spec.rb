require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<system>headermenu", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    @user = FactoryBot.create(:user, :activated)
  end

  describe ":when you login and click headermenu", js: true do
    it "display appropriate links" do
      login_as(@user)
      find(".header_btn").click
      aggregate_failures do
        expect(page.body).to have_link 'Home'
        expect(page.body).to have_link 'About'
        expect(page.body).to have_link 'Contact'
        expect(page.body).to have_link 'ログアウト'
        expect(page.body).to have_link 'プロフィール'
        expect(page.body).to have_link 'アカウント更新'
        expect(page.body).to have_link '記事作成'
        expect(page.body).to have_link '質問作成'
        expect(page.body).to have_link '通知設定'
        expect(page.body).to have_link 'niceリスト'
        expect(page.body).to have_link '記事ブックマーク'
        expect(page.body).to have_link '気になる質問リスト'
        expect(page.body).to have_link '記事投稿リスト'
        expect(page.body).to have_link '質問投稿リスト'
        expect(page.body).not_to have_link 'ユーザー削除'
      end
    end
  end

  describe ":when you  don't login and click headermenu", js: true do
    it "display appropriate links" do
      visit root_path
      find(".header_btn").click
      aggregate_failures do
        expect(page.body).to have_link 'Home'
        expect(page.body).to have_link 'About'
        expect(page.body).to have_link 'Contact'
        expect(page.body).not_to have_link 'ログアウト'
        expect(page.body).not_to have_link 'プロフィール'
        expect(page.body).not_to have_link 'アカウント更新'
        expect(page.body).not_to have_link '記事作成'
        expect(page.body).not_to have_link '質問作成'
        expect(page.body).not_to have_link '通知設定'
        expect(page.body).not_to have_link 'niceリスト'
        expect(page.body).not_to have_link '記事ブックマーク'
        expect(page.body).not_to have_link '気になる記事リスト'
        expect(page.body).not_to have_link '記事投稿リスト'
        expect(page.body).not_to have_link '質問投稿リスト'
        expect(page.body).not_to have_link 'ユーザー削除'
      end
    end
  end
end
