# frozen_string_literal: true

# Picks Helper
module PicksHelper
  def users_no_pick(matchday)
    User.joins(:picks).where('picks.matchday' => matchday, 'picks.team_id' => '')
  end
end
