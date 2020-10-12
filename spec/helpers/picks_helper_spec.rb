# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PicksHelper, type: :helper do
  before :all do
    FactoryBot.create_list(:user, 12)
    Matchday.all.update_all(lock_time: '2030-10-31 12:30:00')
    Pick.where(matchday: 1).update(team_id: 'AVL')
    Pick.where(matchday: 2).limit(7).update(team_id: 'TOT')
  end

  describe '#users_no_pick' do
    let(:no_pick_users) { helper.users_no_pick(2) }

    it 'returns picks only users without picks' do
      expect(no_pick_users.count).to eq(5)
    end
    it 'returns an array of users' do
      expect(no_pick_users).to all(be_a(User))
    end
    it 'returns empty when all users have picked' do
      expect(helper.users_no_pick(1).count).to eq(0)
    end
  end

  describe '#find_pick' do
    it 'returns next team up' do
      test_picks = %w[CHE MUN MCI LIV ARS]
      expect(helper.find_pick(test_picks)).to eq('LEI')
    end
  end
end
