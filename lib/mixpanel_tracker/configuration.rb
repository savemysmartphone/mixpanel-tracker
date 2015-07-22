module MixpanelTracker
  module Configuration
    EnvironmentConfiguration = Struct.new(:token, :block)
    ENVIRONMENTS = %i(production staging development test)

    @configuration = {}.with_indifferent_access

    ENVIRONMENTS.each do |env|
      @configuration[env] = EnvironmentConfiguration.new(nil, nil)
    end

    class << self
      def [](v)
        @configuration[v]
      end

      def method_missing(method_name, *args, &block)
        method_name = method_name.to_sym
        return super unless ENVIRONMENTS.include? method_name
        if !block_given? && args.length != 1
          raise ArgumentError, "wrong number of arguments (#{args.length} for 0..1 or block)"
        end
        @configuration[method_name] = EnvironmentConfiguration.new(args[0],block_given? ? block : nil)
      end
    end
  end
end
