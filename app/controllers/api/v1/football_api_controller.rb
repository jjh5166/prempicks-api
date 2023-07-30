# frozen_string_literal: true

module Api
  module V1
    # FootballApi Controller
    class FootballApiController < ApplicationController
      # get /epl/schedule
      def schedule
        schedule_from_cache = REDIS.get('epl-schedule')
        if schedule_from_cache
          puts 'Using cache for epl schedule'
          render json: JSON.parse(schedule_from_cache)
        else
          puts 'No EPL schedule in cache. Requesting...'
          response = FootballData::Client.matches
          render json: response
          REDIS.setex('epl-schedule', 86_400, response.to_json)
        end
      rescue StandardError => e
        render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
      end

      # get /epl/table
      def table
        schedule_from_cache = REDIS.get('epl-table')
        if schedule_from_cache
          puts 'Using cache for epl table'
          render json: JSON.parse(schedule_from_cache)
        else
          puts 'No EPL table in cache. Requesting...'
          response = FootballDataV4::Client.standings
          render json: response
          REDIS.setex('epl-table', 86_400, response.to_json)
        end
      rescue StandardError => e
        render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
      end
    end
  end
end
