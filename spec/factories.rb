# frozen_string_literal: true

FactoryBot.define do
  pick_team = ALL_TEAMS

  factory :user, class: User do
    uid { Faker::Alphanumeric.unique.alphanumeric(number: 18) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    team_name { Faker::Team.unique.name }
    email { Faker::Internet.unique.email }
    live { true }
  end
end
