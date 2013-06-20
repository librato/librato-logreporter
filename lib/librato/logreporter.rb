module Librato
  class LogReporter

    # Increment a given metric
    #
    # @example Increment metric 'foo' by 1
    #   increment :foo
    #
    # @example Increment metric 'bar' by 2
    #   increment :bar, :by => 2
    #
    def increment(counter, options={})
      by = options[:by] || 1
      log_write(counter => by)
    end

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
      @source
    end

    # set default source
    def source=(source)
      @source = source
    end

    private

    def log_write(args)
      paired = args.map{ |keyval| keyval.join('=') }
      paired.map!{ |element| "measure.#{element}" }
      log.puts paired.join(' ')
    end

  end
end

require 'librato/logreporter/version'