# frozen_string_literal: true

module Api
  module V1
    # Picks Controller
    class PicksController < ApplicationController
      before_action :set_picks, only: %i[my_picks update]
      # GET /mypicks
      def my_picks
        render json: @picks.as_json(only: %i[matchday team_id])
      end

      # PATCH /mypicks
      def update
        params[:picks].each do |pick|
          @picks.where(matchday: pick[0]).update(team_id: pick[1])
        end
      end

      private

      def set_picks
        auth_user = FirebaseIdToken::Signature.verify(params[:idToken])
        @picks = Pick.where(user_uid: auth_user['user_id'])
      end

      # Only allow a trusted parameter "white list" through.
      def pick_params
        params.require(:pick).permit(:user_id, :matchday, :team_id)
      end
    end
  end
end
