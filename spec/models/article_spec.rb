require 'rails_helper'

RSpec.describe Article, type: :model do
  context ":set @article" do
    before do
      @article = FactoryBot.build(:article)
    end

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

  context ":about article placemnt" do
    let!(:no1) { FactoryBot.create(:article, :yesterday) }
    let!(:no2) { FactoryBot.create(:article, :lastyear) }
    let!(:no3) { FactoryBot.create(:article, :now) }

    it "article is sorted in descending order " do
      aggregate_failures 'test with 3 items' do
        expect(Article.first).to eq no3
        expect(Article.second).to eq no1
        expect(Article.third).to eq no2
      end
    end
  end
end
