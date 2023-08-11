# frozen_string_literal: true

module FootballDataV4
  # data fetching from football data API version 4
  class Client
    include HTTParty
    base_uri 'http://api.football-data.org/v4'

    FOOTBALL_API_KEY = ENV['FOOTBALL_API_KEY']

    @options = { headers: { 'X-Auth-Token' => FOOTBALL_API_KEY } }

    def self.standings
      res = get('/competitions/PL/standings', @options)
      JSON.parse(res.body)
    end

    def self.todays_matches
      today = Date.today.to_s
      res = get("/competitions/PL/matches?dateFrom=#{today}&dateTo=#{today}", @options)
      JSON.parse(res.body)
    end

    # def self.matches
    #   res = get('/competitions/PL/matches', @options)
    #   JSON.parse(res.body)
    # end

    # def self.scheduled_matches
    #   res = get('/competitions/PL/matches?status=SCHEDULED', @options)
    #   JSON.parse(res.body)
    # end

    # def self.finished_matches(matchday)
    #   req_url = "/competitions/PL/matches?matchday=#{matchday}&status=FINISHED"
    #   res = get(req_url, @options)
    #   JSON.parse(res.body)
    # end
  end
end
