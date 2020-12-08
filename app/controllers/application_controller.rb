# frozen_string_literal: true

# Application Controller
class ApplicationController < ActionController::API
  def authorize
    auth_user = FirebaseIdToken::Signature.verify(params[:idToken])
    @uid = auth_user ? auth_user['user_id'] : nil
    render json: {}, status: 401 if @uid.nil?
  end

  def current_matchday
    CurrentMatchday.find(1).matchday
  end

  def user_team
    User.find(@uid).team_name
  end
end
