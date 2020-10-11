# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PicksHelper, type: :helper do
  before do
    FactoryBot.create_list(:user, 12)
    Matchday.all.update_all(lock_time: '2030-10-31 12:30:00')
    Pick.where(matchday: 1).update(team_id: 'AVL')
    Pick.where(matchday: 2).limit(7).update(team_id: 'TOT')
  end

  describe '#users_no_pick' do
    it 'returns picks only users without picks' do
      expect(helper.users_no_pick(2).count).to eq(5)
    end
  end

  describe '#find_pick' do
    it 'returns next team up' do
      test_picks = %w[CHE MUN MCI LIV ARS]
      expect(helper.find_pick(test_picks)).to eq('LEI')
    end
  end
end
