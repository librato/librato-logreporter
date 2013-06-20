module Librato
  class LogReporter

    # Encapsulates state for grouping operations
    #
    class Group

      def initialize(options={})
        @collector = options[:collector]
        @prefix = "#{options[:prefix]}."
      end

      def group(prefix)
        prefix = apply_prefix(prefix)
        yield self.class.new(collector: @collector, prefix: prefix)
      end

      def increment(counter, options={})
        counter = apply_prefix(counter)
        @collector.increment counter, options
      end

      def measure(*args, &block)
        args[0] = apply_prefix(args[0])
        @collector.measure(*args, &block)
      end
      alias :timing :measure

      private

      def apply_prefix(str)
        "#{@prefix}#{str}"
      end

    end
  end
end