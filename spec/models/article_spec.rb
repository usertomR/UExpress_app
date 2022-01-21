require 'rails_helper'

RSpec.describe Article, type: :model do
  before do
    @user = FactoryBot.create(:user, :activated)
    @article = FactoryBot.create(:article, user_id: @user.id)
  end

  context ":@article" do
    it "must be valid" do
      expect(@article).to be_valid
    end

    it "has user_id" do
      @article.user_id = nil
      expect(@article).not_to be_valid
    end

    it "has title" do
      @article.title = ""
      expect(@article).not_to be_valid
    end

    it "has title that is at most 100 characters" do
      @article.title = "a" * 101
      expect(@article).not_to be_valid
    end
  end
end
