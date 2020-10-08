# frozen_string_literal: true

FactoryBot.define do
  pick_team = %w[ ARS AVL BHA BUR CHE CRY EVE FUL LEE LEI
                  LIV MCI MUN NEW SHU SOU TOT WBA WHU WOL ]

  factory :user, class: User do
    uid { Faker::String.random(length: 18) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    team_name { Faker::Team.name }
    email { Faker::Internet.email }
  end
end
