module Librato
  class LogReporter

    # Encapsulates state for grouping operations
    #
    class Group

      def initialize(options={})
        @collector = options[:collector]
        @prefix = "#{options[:prefix]}."
      end

      def increment(counter, options={})
        counter = "#{@prefix}#{counter}"
        @collector.increment counter, options
      end

    end
  end
end