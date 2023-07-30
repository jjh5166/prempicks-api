# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :user, only: %i[create show update]
      get '/mypicks' => 'picks#my_picks'
      patch '/mypicks' => 'picks#update'
      get '/standings' => 'picks#standings'
      get '/score-matchday' => 'scores#trigger_score_matchday'
      post 'user/opt-in' => 'users#opt_in'
      get 'epl/schedule' => 'football_api#schedule'
      get 'epl/table' => 'football_api#table'
    end
  end

  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'

  # Configure Sidekiq-specific session middleware
  Sidekiq::Web.use ActionDispatch::Cookies
  Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_interslice_session'

  if Rails.env.production?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username),
                                                  ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_USERNAME'])) &
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password),
                                                    ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD']))
    end
  end
  mount Sidekiq::Web, at: '/sidekiq'
end
