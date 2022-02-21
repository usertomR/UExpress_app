require 'rails_helper'
require './spec/support/test_helper'

# @others：最初は空の配列。直後にUserクラスのインスタンスを入れていく
# フォロー/フォロワー数・・@user:3/4  @othersは全て0/0
RSpec.describe "<system>Relationship", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
    @user = FactoryBot.create(:user, :activated)

    @others = []
    5.times do
      @others << FactoryBot.create(:user, :activated)
    end

    @others[0..2].each do |other|
      @user.active_relationships.create!(followed_id: other.id)
    end

    @others[0..3].each do |other|
      @user.passive_relationships.create!(follower_id: other.id)
    end
  end

  describe ":About display of the number of follow/follower" do
    it "anyone can see them" do
      login_as(@user)
      visit user_path(@user)
      aggregate_failures do
        expect(find('#sum_follow')).to have_content "3"
        expect(find('#sum_follower')).to have_content "4"
      end
    end
  end

  describe ":About edit of the number of your follow" do
    context "you can push [フォロー]" do
      it "because you login" do
        login_as(@user)
        visit user_path(@others[4])
        within(".follow_form") do
          click_on 'フォロー'
        end
        aggregate_failures do
          expect(find('#sum_follower')).to have_content "1"
          expect(@user.following.count).to eq 4
        end
      end
    end

    context "you can push [フォロー解除]" do
      it "because you login" do
        login_as(@user)
        visit user_path(@others[0])
        within(".follow_form") do
          click_on 'フォロー解除'
        end
        aggregate_failures do
          expect(find('#sum_follower')).to have_content "0"
          expect(@user.following.count).to eq 2
        end
      end
    end
  end
end
