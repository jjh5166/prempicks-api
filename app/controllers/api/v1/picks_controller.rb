# frozen_string_literal: true

module Api
  module V1
    # Picks Controller
    class PicksController < ApplicationController
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
      end

      # GET /standings
      def standings
        return unless FirebaseIdToken::Signature.verify(params[:idToken])

        currently = current_matchday
        all_picks = standings_picks_up_to(current_matchday)
        render json: {
          'currentMatchday': currently,
          'standings': all_picks
        }
      end

      private

      def set_mypicks
        auth_user = FirebaseIdToken::Signature.verify(params[:idToken])
        @picks = Pick.where(user_uid: auth_user['user_id'])
      end

      def set_schedule
        matches_data = FootballData::Client.matches['matches']
        matches =
          matches_data.sort_by { |match| [match['matchday'], match['utcDate']] }

        @schedule = Hash[(1..38).collect { |md| [md, []] }]
        matches.each_slice(10).with_index do |slice, i|
          slice.each do |match|
            @schedule[i + 1].push(
              Hash[
                'utcDate' => match['utcDate'],
                'status' => match['status'],
                'away' => match['awayTeam'],
                'home' => match['homeTeam'],
                'score' => match['score']['fullTime']
              ]
            )
          end
        end
      end

      def standings_picks_up_to(matchday)
        User.all.includes(:picks)
            .where('picks.matchday <= ?', matchday)
            .references(:picks)
            .map do |user|
          {
            name: user.team_name,
            picks: user.picks.map do |pick|
              { matchday: pick.matchday, team_id: pick.team_id }
            end
          }
        end
      end
    end
  end
end
