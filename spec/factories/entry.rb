FactoryBot.define do
  factory :entry do
    association :user,
      factory: :user,
      strategy: :create,
      activated: true

    association :room,
      factory: :room,
      strategy: :create
  end
end
