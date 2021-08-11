# frozen_string_literal: true

# every user has 38 picks
class Pick < ApplicationRecord
  belongs_to :user, foreign_key: 'user_uid'
  validates :user_uid, uniqueness: { scope: %i[matchday season] }
  validates :team_id, uniqueness: { scope: %i[half user_uid season] }, allow_blank: true, on: :update
  default_scope { order(matchday: :asc) }
  attr_readonly :matchday, :user_uid, :half
  validate :update_before_lock
  validates :team_id, inclusion: { in: %w[ ARS AVL BRE BHA BUR CHE CRY EVE LEE LEI
                                           LIV MCI MUN NEW NOR SOU TOT WAT WHU WOL ] }, allow_blank: true

  private

  def update_before_lock
    lock_time = Matchday.find(matchday).lock_time
    return if DateTime.now.utc < lock_time

    errors.add 'Pick cannot be updated as matchday has started'
  end
end
