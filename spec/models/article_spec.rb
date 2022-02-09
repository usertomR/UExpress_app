require 'rails_helper'

RSpec.describe "<model>Article", type: :model do
  context ":@article" do
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

    it "has unique title" do
      @another = FactoryBot.create(:article)
      user = User.create(name: "Tom", email: "Tom@email.com", password: "Testuser",
                        password_confirmation: "Testuser")
      article = user.articles.build(title: "MyString", accuracy_text: 1, difficultylevel_text: 1,
                                  articletext: "Sample", Eschool_level: true, JHschool_level: false,
                                  user_id: 1, Hschool_level: false)
      article.valid?
      expect(article.errors[:title]).to include("has already been taken")
    end

    it "has title that is at most 100 characters" do
      @article.title = "a" * 101
      expect(@article).not_to be_valid
    end

    it "has (a) target(s)<Eschool or JHschool or Hschool>" do
      @article.Eschool_level = false
      @article.JHschool_level = false
      @article.Hschool_level = false
      expect(@article).not_to be_valid
    end

    it "has artcletext" do
      @article.articletext = ""
      expect(@article).not_to be_valid
    end

    it "is specified about accuracy_text" do
      @article.accuracy_text = nil
      expect(@article).not_to be_valid
    end

    it "is specified about difficultylevel_text" do
      @article.difficultylevel_text = nil
      expect(@article).not_to be_valid
    end
  end

  # FactoryBotについて、過去に作成されたことにしても、updated_atは今現在になってしまう。こうせざるをえない
  context ":about article placemnt" do
    let!(:no1) { FactoryBot.create(:article, :lastyear) }
    let!(:no2) { FactoryBot.create(:article, :yesterday) }
    let!(:no3) { FactoryBot.create(:article, :now) }

    it "article is sorted by date last modified (最終更新日順にソート) " do
      aggregate_failures 'test with 3 items' do
        no1.updated_at = Time.current.prev_year
        no1.save
        no2.updated_at = Time.current.yesterday
        no2.save
        expect(Article.first).to eq no3
        expect(Article.second).to eq no2
        expect(Article.third).to eq no1
      end
    end

    it "article is sorted by date last modified <ver2> " do
      aggregate_failures 'test with 3 items' do
        no2.updated_at = Time.current.yesterday
        no2.save
        no1.updated_at = Time.current.prev_year
        no1.save
        no3.updated_at = Time.current.prev_month
        no3.save
        expect(Article.first).to eq no2
        expect(Article.second).to eq no3
        expect(Article.third).to eq no1
      end
    end
  end
end
