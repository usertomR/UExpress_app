# ユーザーを重複させないときだけ使う。作成する度にemailが変わるから。
FactoryBot.define do
  factory :user do
    name { "Tester" }
    sequence(:email) { |n| "Tester#{n}@email.com" }
    password { "Tester" }
    password_confirmation { "Tester" }
  end
end
