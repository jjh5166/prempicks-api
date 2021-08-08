# frozen_string_literal: true

module Api
  module V1
    # Users Controller
    class UsersController < ApplicationController
      before_action :authorize
      before_action :set_user, only: %i[show update, opt_in]

      # GET /api/user
      def show
        render json: @user
      end

      # POST /api/user
      def create
        @user = User.new(user_params)
        # to do: use static value in new method
        @user.update(live: true)
        if @user.save
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/user
      def update
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # POST /api/user
      def opt_in
        if @user.update(live: true)
          opt_in_seed_picks
          render json: { status: 200, message: 'OK' }
        else
          render json: { message: 'There was an error opting in' }, status: 500
        end
      end
      private

      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(@uid)
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:uid, :email, :first_name, :last_name, :team_name)
      end

      def opt_in_seed_picks
        (1..38).each do |n|
          h = n < 20 ? 1 : 2
          # to do: get season from cache
          Pick.new(user_uid: @user.uid, matchday: n, half: h, season: "2021").save(validate: false)
        end
      end
    end
  end
end
