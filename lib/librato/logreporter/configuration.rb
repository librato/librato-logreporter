module Librato
  class LogReporter

    # Handles configuration options and intelligent defaults
    # for the LogReporter class.
    #
    module Configuration

      # current IO to log to
      def log
        @log ||= $stdout
      end

      # set IO to log to
      def log=(io)
        @log = io
      end

      # current default source
      def source
        @source ||= ENV['LIBRATO_SOURCE']
      end

      # set default source
      def source=(source)
        @source = source
      end

    end
  end
end