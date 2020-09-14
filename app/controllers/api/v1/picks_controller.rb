# frozen_string_literal: true

module Api
  module V1
    # Picks Controller
    class PicksController < ApplicationController
      before_action :authorize
      before_action :set_mypicks, only: %i[my_picks update]
      before_action :set_schedule, only: %i[my_picks]

      # GET /mypicks
      def my_picks
        render json: {
          'picks': @picks.as_json(only: %i[matchday team_id]),
          'matches': @schedule
        }
      end

      # PATCH /mypicks
      def update
        params[:picks].each do |pick|
          @picks.where(matchday: pick[0]).update(team_id: pick[1])
        end
        render json: { status: 200, message: 'OK' }
      end

      # GET /standings
      def standings
        currently = current_matchday
        all_picks = standings_picks_up_to(current_matchday)
        render json: {
          'currentMatchday': currently,
          'standings': all_picks
        }
      end

      private

      def set_mypicks
        @picks = Pick.where(user_uid: @uid)
      end

      def set_schedule
        matches = sorted_matches

        @schedule = Hash[(1..38).collect { |md| [md, []] }]
        matches.each_slice(10).with_index do |slice, i|
          slice.each do |match|
            @schedule[i + 1].push(match_hash(match))
          end
        end
      end

      def match_hash(match)
        Hash[
          'utcDate' => match['utcDate'],
          'status' => match['status'],
          'away' => match['awayTeam'],
          'home' => match['homeTeam'],
          'score' => match['score']['fullTime']
        ]
      end

      def sorted_matches
        matches_data = FootballData::Client.matches['matches']
        matches_data.sort_by { |match| [match['matchday'], match['utcDate']] }
      end

      def standings_picks_up_to(matchday)
        User.all.includes(:picks).where('picks.matchday <= ?', matchday).references(:picks)
            .map do |user|
          { name: user.team_name, picks: user.picks.map do |pick|
            { matchday: pick.matchday, team_id: pick.team_id }
          end }
        end
      end
    end
  end
end
