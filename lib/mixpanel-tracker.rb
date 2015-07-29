require 'mixpanel-ruby'

module MixpanelTracker
  autoload :Configuration, 'mixpanel_tracker/configuration'

  def mixpanel(token)
    @mixpanel ||= Mixpanel::Tracker.new(token)
  end

  def mixpanel_tracker(event, opts = {})
    config_env = MixpanelTracker::Configuration[Rails.env]
    if config_env.token
      mixpanel(config_env.token).track(current_user.id, event, opts, request.ip)
    end
    if config_env.block
      config_env.block.call(current_user, event, opts)
    end
  end

  def mixpanel_people_tracker(opts = {})
    config_env = MixpanelTracker::Configuration[Rails.env]
    if config_env.token
      mixpanel(config_env.token).people.set(current_user.id, opts)
    end
    if config_env.block
      config_env.block.call(current_user, 'people_tracker', opts)
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
        options = {}
        options[:resource_sg] = "#{controller_name.singularize}"
        options[:resource_pl] = "#{controller_name}"
        mixpanel_tracker(I18n.t("mixpanel.default.#{params[:action]}", options), opts)
      end
    end

    def mixpanel_people_tracker(*args, &block)
      after_action(*args) do
        opts = block_given? ? instance_eval(&block) : {}
        mixpanel_people_tracker(opts)
      end
    end
  end
end
