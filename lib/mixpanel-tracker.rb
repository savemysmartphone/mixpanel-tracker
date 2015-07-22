module MixpanelTracker
  autoload :Configuration, 'mixpanel_tracker/configuration'

  def mixpanel(token)
    @mixpanel ||= Mixpanel::Tracker.new(token)
  end

  def mixpanel_tracker(event, opts = {})
    config_env = MixpanelTracker::Configuration[Rails.env]
    if config_env.token
      mixpanel(config_env.token).track(current_saver.id, event, opts, request.ip)
    end
    if config_env.block
      config_env.block.call(event, opts)
    end
  end

  class << self
    def included(base)
      base.send(:extend, MixpanelTracker::Extension)
    end

    def configure
      yield MixpanelTracker::Configuration
    end
  end

  module Extension
    def mixpanel_tracker(*args, &block)
      after_action(*args) do
        opts = block_given? ? instance_eval(&block) : {}
        mixpanel_tracker(I18n.t("mixpanel.#{params[:controller]}.#{params[:action]}"), opts)
      end
    end
  end
end
