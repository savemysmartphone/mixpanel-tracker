MixpanelTracker.configure do |config|
  config.production(ENV['SAVE_MIXPANEL_TOKEN'])

  config.staging(ENV['SAVE_MIXPANEL_TOKEN']) do |action, options|
    Rails.logger.info "#{action} => #{options.inspect}"
  end

  config.development do |action, options|
    Rails.logger.info "#{action} => #{options.inspect}"
  end

  config.test nil
end
