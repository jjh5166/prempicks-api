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
          'currentMatchday': CurrentMatchday.find(1).matchday,
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
        locked_mds = Matchday.where(locked: true).pluck(:id)
        picks = standings_picks_for(locked_mds)
        scores = scores_for(locked_mds)
        render json: {
          'standings': picks,
          'scores': scores,
          'userTeam': user_team
        }
      end

      private

      def set_mypicks
        @picks = Pick.where(user_uid: @uid, season: "2021")
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

      def scores_for(matchdays)
        scores_query = Score.where(matchday_id: matchdays, season: "2021").group_by(&:matchday_id)
        scores_hash = {}
        scores_query.each do |md, md_scores|
          scores_hash[md] = {}
          md_scores.each do |m|
            scores_hash[md][m.team_id] = m.points
          end
        end
        scores_hash
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
        matches_data.sort_by { |match| [match['matchday'], match['status'] != 'POSTPONED' ? 0 : 1, match['utcDate']] }
      end

      def standings_picks_for(matchdays)
        User.all.includes(:picks) ##have to add season
            .where(picks: { matchday: matchdays, season: "2021" })
            .order('picks.matchday DESC')
            .references(:picks)
            .map do |user|
          { name: user.team_name, picks: user.picks.map do |pick|
            { matchday: pick.matchday, team_id: pick.team_id }
          end }
        end
      end
    end
  end
end
