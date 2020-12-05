# frozen_string_literal: true

module FootballData
  # data fetching from football data API
  class Client
    include HTTParty
    base_uri 'http://api.football-data.org/v2'

    @options = { headers: { 'X-Auth-Token' => ENV['FOOTBALL_API_KEY'] } }

    def self.standings
      res = get('/competitions/2021/standings', @options)
      JSON.parse(res.body)
    end

    def self.matches
      res = get('/competitions/2021/matches', @options)
      JSON.parse(res.body)
    end

    def self.scheduled_matches
      res = get('/competitions/2021/matches?status=SCHEDULED', @options)
      JSON.parse(res.body)
    end

    def self.finished_matches(matchday)
      req_url = "/competitions/2021/matches?matchday=#{matchday}&status=FINISHED"
      res = get(req_url, @options)
      JSON.parse(res.body)
    end
  end
end
