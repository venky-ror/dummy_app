require 'faker'
FactoryBot.define do
  factory :article do
    title { Faker::Name.name }
    body { Faker::Internet.email }
  end
end