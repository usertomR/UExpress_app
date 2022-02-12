# ユーザーが重複しないときに使う。作成する度にemailが変わるから。
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Tester#{n}" }
    sequence(:email) { |n| "Tester#{n}@email.com" }
    password { "Tester" }
    password_confirmation { "Tester" }
    activated { false }

    trait :admin do
      admin { true }
    end

    trait :activated do
      activated { true }
    end
  end
end
