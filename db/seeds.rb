# frozen_string_literal: true

if Matchday.none?
  (1..38).each do |week|
    Matchday.create(id: week)
  end
  # update locktimes
end
