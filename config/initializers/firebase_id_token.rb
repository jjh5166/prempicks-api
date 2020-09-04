FirebaseIdToken.configure do |config|
  config.project_ids = [ENV['FIREBASE_APP_ID']]
end
