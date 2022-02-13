require 'rails_helper'

RSpec.describe "<model>Question", type: :model do
  context ":@question" do
    before do
      @question = FactoryBot.build(:question)
    end

    it "must be valid" do
      expect(@question).to be_valid
    end

    it "has user_id" do
      @question.user_id = nil
      expect(@question).not_to be_valid
    end

    it "has title" do
      @question.title = ""
      expect(@question).not_to be_valid
    end

    it "has unique title" do
      @another = FactoryBot.create(:question)
      user = User.create(name: "Tom", email: "Tom@email.com", password: "Testuser",
                        password_confirmation: "Testuser")
      article = user.questions.build(title: "MyString", accuracy_text: 1, difficultylevel_text: 1,
                                  questiontext: "Sample", Eschool_level: true, JHschool_level: false,
                                  Hschool_level: false, user_id: 1, solve: false)
      article.valid?
      expect(article.errors[:title]).to include("has already been taken")
    end

    it "has title that is at most 100 characters" do
      @question.title = "a" * 101
      expect(@question).not_to be_valid
    end

    it "has (a) target(s)<Eschool or JHschool or Hschool>" do
      @question.Eschool_level = false
      @question.JHschool_level = false
      @question.Hschool_level = false
      expect(@question).not_to be_valid
    end

    it "has questiontext" do
      @question.questiontext = ""
      expect(@question).not_to be_valid
    end

    it "is specified about accuracy_text" do
      @question.accuracy_text = nil
      expect(@question).not_to be_valid
    end

    it "is specified about difficultylevel_text" do
      @question.difficultylevel_text = nil
      expect(@question).not_to be_valid
    end

    it "is vaild when @question.solve is false" do
      @question.solve = false
      expect(@question).to be_valid
    end
  end

  # FactoryBotについて、過去に作成されたことにしても、updated_atは今現在になってしまう。こうせざるをえない
  context ":about article placemnt" do
    let!(:no1) { FactoryBot.create(:question, :lastyear) }
    let!(:no2) { FactoryBot.create(:question, :yesterday) }
    let!(:no3) { FactoryBot.create(:question, :now) }

    it "article is sorted by date last modified (最終更新日順にソート) " do
      aggregate_failures 'test with 3 items' do
        no1.updated_at = Time.current.prev_year
        no1.save
        no2.updated_at = Time.current.yesterday
        no2.save
        expect(Question.first).to eq no3
        expect(Question.second).to eq no2
        expect(Question.third).to eq no1
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
        expect(Question.first).to eq no2
        expect(Question.second).to eq no3
        expect(Question.third).to eq no1
      end
    end
  end
end
