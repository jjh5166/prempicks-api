# frozen_string_literal: true

# update before each season

# year in which season starts
CURRENT_SEASON = '2022'

# ordered by last years standings for convenience of autopick
ALL_TEAMS = %w[ MCI LIV CHE TOT ARS MUN WHU LEI BHA WOL
                NEW CRY BRE AVL SOU EVE LEE FUL BOU NOT ].freeze

TOP_SIX = ALL_TEAMS.first(6).freeze

NEWLY_PROMOTED = ALL_TEAMS.last(3).freeze