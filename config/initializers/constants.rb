# frozen_string_literal: true

# update before each season

# year in which season starts
CURRENT_SEASON = '2024'

# ordered by last years standings for convenience of autopick
ALL_TEAMS = %w[MCI ARS LIV AVL TOT CHE NEW MUN WHU CRY
               BHA BOU FUL WOL EVE BRE NOT LEI IPS SOU].freeze

TOP_SIX = ALL_TEAMS.first(6).freeze

NEWLY_PROMOTED = ALL_TEAMS.last(3).freeze
