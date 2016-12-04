CarrierWave.configure do |config|
  config.root = Rails.root

  if Rails.env.production?
    config.storage = :aws
    config.aws_bucket = ENV.fetch('S3_BUCKET')
    config.aws_acl = 'public-read'

    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

    config.aws_credentials = {
      access_key_id: ENV.fetch( "S3_KEY" ),
      secret_access_key: ENV.fetch( "S3_SECRET" ),
      region: ENV.fetch( "S3_REGION" )
    }
  else
    config.storage = :file
  end
end
