Airbrake.configure do |config|
    config.api_key = '9195caa918967f6ca8af4aee618c76d6'
    config.host    = 'errbit.hut.shefcompsci.org.uk'
    config.port    = 443
    config.secure  = config.port == 443
  end