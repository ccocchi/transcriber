CarrierWave.configure do |config|
  #config.fog_provider = 'fog-google'
  config.fog_credentials = {
    provider:                         'Google',
    google_storage_access_key_id:     'GOOGGZJOMLNNXC744GB2',
    google_storage_secret_access_key: 'Z9WvC73boQZpZHmNNCY3V+BQS7Wq9YYTJRbc9jEc'
  }
  config.fog_directory = 'haymakerforever'
  config.fog_public = true
end
