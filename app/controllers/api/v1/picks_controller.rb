# frozen_string_literal: true

module Api
  module V1
    # Picks Controller
    class PicksController < ApplicationController
      include ScoringHelper
      before_action :authorize
      before_action :set_mypicks, only: %i[my_picks update]
      before_action :set_schedule, only: %i[my_picks]
      after_action :scoring_check, only: %i[standings]

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
        if locked_mds.length > 0
          picks = standings_picks_for(locked_mds)
          scores = scores_for(locked_mds)
          render json: {
            'standings': picks,
            'scores': scores,
            'userTeam': user_team
          }
        else
          team_list = User.where(live: true).pluck(:first_name, :last_name, :team_name)
          render json: {
            'teams': team_list
          }
        end
      end

      private

      def set_mypicks
        @picks = Pick.where(user_uid: @uid, season: CURRENT_SEASON)
      end

      def set_schedule
        schedule_from_cache = REDIS.get('pick-schedule')
        if schedule_from_cache
          @schedule = JSON.parse(schedule_from_cache)
          puts 'Using cache for My Picks Schedule'
        else
          matches = sorted_matches

          @schedule = Hash[(1..38).collect { |md| [md, []] }]
          matches.each_slice(10).with_index do |slice, i|
            slice.each do |match|
              @schedule[i + 1].push(match_hash(match))
            end
          end
          REDIS.setex('pick-schedule', 86_400, @schedule.to_json)
        end
      end

      def scores_for(matchdays)
        scores_query = Score.where(matchday_id: matchdays, season: CURRENT_SEASON).group_by(&:matchday_id)
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
        User.all.includes(:picks) # have to add season
            .where(picks: { matchday: matchdays, season: CURRENT_SEASON })
            .order('picks.matchday DESC')
            .references(:picks)
            .map do |user|
          { name: user.team_name, picks: user.picks.map do |pick|
            { matchday: pick.matchday, team_id: pick.team_id }
          end }
        end
      end

      def scoring_check
        return unless timestamp_check

        slate_from_redis = REDIS.get('daily-slate')
        slate = slate_from_redis ? JSON.parse(slate_from_redis) : nil
        puts 'slate'
        puts slate
        return unless slate

        matches_to_score = slate.select do |match|
          scored = match['scored']
          date = Time.parse(match['utcDate'])

          # Check if the date is more than 1 hour and 50 minutes in the past
          time_difference = Time.now.utc - date
          scored == false && time_difference > (1 * 60 + 50) * 60
        end

        return if matches_to_score.empty?

        matchday = matches_to_score.first['matchday']

        score_matchday(matchday)
        # TEMPORARY UNTIL SCORING FIXED
        REDIS.del('daily-slate')
      end

      def timestamp_check
        stored_time_str = REDIS.get('score-check-timestamp')
        stored_time = Time.parse(stored_time_str)

        current_time = Time.now.utc.to_s
        REDIS.set('score-check-timestamp', current_time)
        Time.now.utc - stored_time >= 120
      end
    end
  end
end
