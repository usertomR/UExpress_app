FactoryBot.define do
  factory :article do
    title { "MyString" }
    accuracy_text { 1 }
    difficultylevel_text { 1 }
    articletext { "MyText" }
    Eschool_level { false }
    JHschool_level { false }
    Hschool_level { false }
    user { nil }
  end
end
