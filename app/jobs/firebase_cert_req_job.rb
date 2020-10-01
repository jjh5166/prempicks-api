# frozen_string_literal: true

# request Firebase certificates
class FirebaseCertReqJob < ActiveJob::Base
  def perform
    FirebaseIdToken::Certificates.request!
  end
end
