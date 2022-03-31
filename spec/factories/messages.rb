FactoryBot.define do
  factory :message do
    content { "using RSpec now!" }
    association :user,
      factory: :user,
      strategy: :create,
      activated: true

    association :room,
      factory: :room,
      strategy: :create
  end
end
