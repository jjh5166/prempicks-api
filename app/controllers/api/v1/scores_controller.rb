# frozen_string_literal: true

module Api
  module V1
    # Scores Controller
    class ScoresController < ApplicationController
      def trigger_score_matchday
        ScorerWorker.perform_async(params[:matchday].to_i)
      end
    end
  end
end
