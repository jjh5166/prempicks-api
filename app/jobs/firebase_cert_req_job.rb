# frozen_string_literal: true

# request Firebase certificates
class FirebaseCertReqJob < ApplicationJob
  def perform
    FirebaseIdToken::Certificates.request!
  end
end
