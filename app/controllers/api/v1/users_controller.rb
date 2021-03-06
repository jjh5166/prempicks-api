# frozen_string_literal: true

module Api
  module V1
    # Users Controller
    class UsersController < ApplicationController
      before_action :authorize
      before_action :set_user, only: %i[show update]

      # GET /api/user
      def show
        render json: @user
      end

      # POST /api/user
      def create
        @user = User.new(user_params)

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

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(@uid)
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:uid, :email, :first_name, :last_name, :team_name)
      end
    end
  end
end
