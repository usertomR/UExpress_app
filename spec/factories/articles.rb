FactoryBot.define do
  factory :article do
    title { "MyString" }
    accuracy_text { 1 }
    difficultylevel_text { 1 }
    articletext { "MyText" }
    Eschool_level { false }
    JHschool_level { false }
    Hschool_level { false }

    association :user,
      factory: :user,
      strategy: :create,
      activated: true

    trait :lastyear do
      title { "posted lastyear" }
      created_at { Time.zone.now.prev_year }
    end

    trait :yesterday do
      title { "posted yseterday" }
      created_at { 1.day.ago }
    end

    trait :now do
      title { "post now" }
      created_at { Time.zone.now }
    end
  end
end
