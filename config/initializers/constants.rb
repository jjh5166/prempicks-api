# frozen_string_literal: true

# update before each season

# year in which season starts
CURRENT_SEASON = '2023'

# ordered by last years standings for convenience of autopick
ALL_TEAMS = %w[ MCI ARS MUN NEW LIV BHA AVL TOT BRE FUL 
                CRY CHE WOL WHU BOU NOT EVE BUR SHE LUT ].freeze

TOP_SIX = ALL_TEAMS.first(6).freeze

NEWLY_PROMOTED = ALL_TEAMS.last(3).freeze