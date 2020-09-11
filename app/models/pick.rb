# frozen_string_literal: true

# every user has 38 picks
class Pick < ApplicationRecord
  belongs_to :user, foreign_key: 'user_uid'
  validates :user_uid, uniqueness: { scope: :matchday }
  validates :team_id, uniqueness: { scope: %i[half user_uid] }, allow_blank: true, on: :update
  default_scope { order(matchday: :asc) }
  attr_readonly :matchday, :user_uid, :half
end
