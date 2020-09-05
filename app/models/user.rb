# frozen_string_literal: true

# User model with firebase uid as primary key
class User < ApplicationRecord
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
end
