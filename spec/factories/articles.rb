FactoryBot.define do
  factory :article do
    title { "MyString" }
    accuracy_text { 1 }
    difficultylevel_text { 1 }
    articletext { "MyText" }
    Eschool_level { false }
    JHschool_level { false }
    Hschool_level { true }

    association :user,
      factory: :user,
      strategy: :create,
      activated: true

    trait :lastyear do
      title { "posted lastyear" }
      created_at { Time.current.prev_year }
      updated_at { Time.current.prev_year }
    end

    trait :yesterday do
      title { "posted yesterday" }
      created_at { Time.current.yesterday }
      updated_at { Time.current.yesterday }
    end

    trait :now do
      title { "post now" }
      created_at { Time.zone.now }
      updated_at { Time.zone.now }
    end
  end
end
