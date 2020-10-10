# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PicksHelper, type: :helper do
  before do
    FactoryBot.create_list(:user, 12)
    Matchday.all.update_all(lock_time: '2030-10-31 12:30:00')
    Pick.where(matchday: 1).limit(7).update(team_id: 'TOT')
  end

  describe '#users_no_pick' do
    it 'returns picks only users without picks' do
      expect(helper.users_no_pick(1).count).to eq(5)
    end
  end
end
