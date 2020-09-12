# frozen_string_literal: true

# Application Controller
class ApplicationController < ActionController::API
  def current_matchday
    CurrentMatchday.find(1).matchday
  end
end
