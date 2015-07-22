require 'active_support/configurable'

module MixpanelTracker
  include ActiveSupport::Configurable

  def mixpanel
    @mixpanel ||= MixpanelMixpanel::Tracker.new(ENV['SAVE_MIXPANEL_TOKEN'])
  end

  def mixpanel_tracker(event, opts = {})
    if Rails.env.production?
      mixpanel.track(current_saver.id, event, opts, request.ip)
    else
      Rails.logger.info "#{event}___#{params[:controller]}=>#{params[:action]} ____ #{opts}"
    end
  end

  class << self
    def included(base)
      base.send(:extend, MixpanelTracker::Extension)
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
