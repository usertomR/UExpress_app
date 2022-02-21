require 'rails_helper'
require './spec/support/test_helper'

RSpec.describe "<system>users#show  and other action related it", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    @user = FactoryBot.create(:user, :activated)
    @another = FactoryBot.create(:user, :activated)
    @user.active_relationships.create!(followed_id: @another.id)
    @user.passive_relationships.create!(follower_id: @another.id)
    login_as(@user)
    visit user_path(@another)
  end

  describe "about view of users#show・・" do
    context "check  items・・" do
      it "links are 6" do
        aggregate_failures do
          expect(page).to have_link "記事投稿リスト", href: article_path(@another)
          expect(page).to have_link "質問投稿リスト", href: question_path(@another)
          expect(page).to have_link "フォロー数", href: user_following_path(@another)
          expect(page).to have_link @another.following.count, href: user_following_path(@another)
          expect(page).to have_link "フォロワー数", href: user_follower_path(@another)
          expect(page).to have_link @another.followers.count, href: user_follower_path(@another)
        end
      end
    end
  end

  describe "about view of users#following・・" do
    context "check items ・・" do
      it "an appropriate link is here" do
        click_on "フォロー数"
        expect(page).to have_link @user.name, href: user_path(@user)
      end
    end
  end

  describe "about view of users#follower・・" do
    context "check items ・・" do
      it "an appropriate link is here" do
        click_on "フォロワー数"
        expect(page).to have_link @user.name, href: user_path(@user)
      end
    end
  end
end
