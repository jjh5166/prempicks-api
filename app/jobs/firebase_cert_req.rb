# frozen_string_literal: true

# request Firebase certificates
class FirebaseCertReq < ActiveJob::Base
  def perform
    FirebaseIdToken::Certificates.request!
  end
end
