# frozen_string_literal: true

module Api
  module V1
    # Picks Controller
    class PicksController < ApplicationController
      # GET /mypicks
      def my_picks
        auth_user = FirebaseIdToken::Signature.verify(params[:idToken])
        @picks = Pick.where(user_uid: auth_user['user_id'])

        render json: @picks
      end

      # PATCH/PUT /mypicks
      def update
        if @pick.update(pick_params)
          render json: @pick
        else
          render json: @pick.errors, status: :unprocessable_entity
        end
      end

      private

      # Only allow a trusted parameter "white list" through.
      def pick_params
        params.require(:pick).permit(:user_id, :matchday, :team_id)
      end
    end
  end
end
