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
    # @example Increment metric 'foo' by 1 with a custom source
    #   increment :foo, :source => user.id
    #
    def increment(counter, options={})
      by = options[:by] || 1
      log_write(counter => by, :source => options[:source])
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

    # take key/value pairs and return an array of measure strings
    def add_prefixes(measures)
      prefix = 'measure.'
      measures.map { |keyval|
        key = keyval[0].to_sym
        joined = keyval.join('=')
        if key == :source
          joined
        else
          prefix + joined
        end
      }
    end

    # add default source as appropriate
    def manage_source(measures)
      if source && !measures[:source]
        measures[:source] = source  # set default source
      end
      if !source && measures.has_key?(:source) && !measures[:source]
        measures.delete(:source)    # remove empty source
      end
      measures
    end

    def log_write(measures)
      measure_chunks = add_prefixes(manage_source(measures))
      log.puts measure_chunks.join(' ')
    end

  end
end

require 'librato/logreporter/version'