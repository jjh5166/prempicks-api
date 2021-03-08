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

  describe '#make_autopick ' do
    let!(:user) { User.order('RANDOM()').first}
    let!(:future_pick) {user.picks.find_by(matchday: 23)}

    context 'when an autopick team has been picked in a future matchday' do
      before do
        future_pick.update(team_id: 'LIV')
        helper.make_autopick(user, 'LIV', 21)
      end
      it 'updates future picked team to blank string' do
        be_blank_pick = user.picks.find_by(matchday: 23)
        expect(be_blank_pick.team_id).to eq('')
      end
      it 'successfully autopicks this matchday' do
        expect(user.picks.find_by(matchday: 21).team_id).to eq('LIV')
      end
    end

    context 'when matchday order deviates' do
      before do
        testing_mds = [31, 32, 33, 34, 36, 37]
        test_picks = user.picks.where(matchday: testing_mds)
        team_ids = ['LIV', 'MCI', 'LEI', 'CHE', 'TOT', 'WOL']
        test_picks.each do |pick|
          pick.update(team_id: team_ids.shift) if pick.team_id == ''
        end
        Matchday.where(id: testing_mds).update_all(locked: true)
      end
      it 'correct autopick is still made' do
        puts user.picks.where(half: 2).pluck(:team_id)
        helper.auto_pick(35, [user])
        expect(user.picks.find_by(matchday: 35).team_id).to eq('MUN')
      end
    end
  end
end
