# frozen_string_literal: true

# User model with firebase uid as primary key
class User < ApplicationRecord
  has_many :picks, primary_key: 'uid', foreign_key: 'user_uid'
  after_create :seed_picks
  validates :uid, presence: true, uniqueness: {
    message: 'User already exists'
  }
  validates :email, presence: true, uniqueness: {
    message: 'This email is already in use.'
  }
  validates :team_name, presence: true, uniqueness: {
    message: 'This team name has already been taken'
  }
  self.primary_key = 'uid'

  private

  def seed_picks
    (1..38).each do |n|
      h = n < 20 ? 1 : 2
      Pick.new(user_uid: uid, matchday: n, half: h).save
    end
  end
end
