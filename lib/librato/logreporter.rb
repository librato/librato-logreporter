require_relative 'logreporter/configuration'
require_relative 'logreporter/group'
require_relative 'logreporter/version'

module Librato

  # Provides a common interface to reporting metrics with methods
  # like #increment, #measure, #timing, #group - all written
  # to your preferred IO stream.
  #
  class LogReporter
    include Configuration

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

    # @example Simple measurement
    #   measure 'sources_returned', sources.length
    #
    # @example Simple timing in milliseconds
    #   timing 'myservice.lookup', 2.31
    #
    # @example Block-based timing
    #   timing 'db.query' do
    #     do_my_query
    #   end
    #
    # @example Custom source
    #    measure 'user.all_orders', user.order_count, :source => user.id
    #
    def measure(*args, &block)
      options = {}
      event = args[0].to_s
      returned = nil

      # handle block or specified argument
      if block_given?
        start = Time.now
        returned = yield
        value = ((Time.now - start) * 1000.0).to_i
      elsif args[1]
        value = args[1]
      else
        raise "no value provided"
      end

      # detect options hash if present
      if args.length > 1 and args[-1].respond_to?(:each)
        options = args[-1]
      end

      log_write(event => value, :source => options[:source])
      returned
    end
    alias :timing :measure

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
