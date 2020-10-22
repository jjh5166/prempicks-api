# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScoringHelper, type: :helper do
  before :all do
    Score.where(matchday_id: 1, team_id: %w[ARS AVL BUR CHE]).update(points: 1)
    Score.where(matchday_id: 2).update(points: 1)
  end

  describe '#unscored_scores' do
    it 'only returns scores without teams' do
      expect(helper.unscored_scores(1).count).to eq(16)
    end
    it 'returns [] if all scored for matchday' do
      expect(helper.unscored_scores(2)).to eq([])
    end
  end

  describe '#add_bonus_point' do
    it 'adds point to winner' do
      scores1 = [4, -3]
      helper.add_bonus_point(scores1)
      expect(scores1).to eq([5, -3])
      scores2 = [-3, 3]
      helper.add_bonus_point(scores2)
      expect(scores2).to eq([-3, 4])
    end
  end

  describe '#deduct_point' do
    it 'deducts point from loser' do
      scores1 = [4, -3]
      helper.deduct_point(scores1)
      expect(scores1).to eq([4, -4])
      scores2 = [-3, 3]
      helper.deduct_point(scores2)
      expect(scores2).to eq([-4, 3])
    end
  end
end
