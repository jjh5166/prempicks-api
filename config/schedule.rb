# frozen_string_literal: true

every 1.hour do
  rake 'firebase:certificates:force_request'
end
