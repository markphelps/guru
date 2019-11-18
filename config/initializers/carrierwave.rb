CarrierWave.configure do |config|
  if Rails.env.production?
    config.fog_credentials = {
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
      :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    }
    config.storage = :fog
    config.cache_dir = "#{Rails.root}/tmp/uploads"  # To let CarrierWave work on heroku
    config.fog_directory    = ENV['S3_BUCKET_NAME']
  else
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  end
end
