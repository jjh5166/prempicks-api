# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :user, only: %i[create show update]
      get '/mypicks' => 'picks#my_picks'
      patch '/mypicks' => 'picks#update'
      get '/standings' => 'picks#standings'
    end
  end
end
