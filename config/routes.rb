# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resource :user, only: %i[create show update]
  end
end
