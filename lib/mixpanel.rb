module Mixpanel
  class << self
    def new_tracker
      Mixpanel::Tracker.new(ENV['SAVE_MIXPANEL_TOKEN'])
    end
  end
end
