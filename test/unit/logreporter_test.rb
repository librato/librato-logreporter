require 'test_helper'
require 'stringio'

module Librato
  class LogReporterTest < MiniTest::Test

    def setup
      @buffer   = StringIO.new
      @reporter = LogReporter.new
      @reporter.log = @buffer
    end

    def test_increment
      @reporter.increment :foo
      assert_last_logged 'measure.foo=1'

      @reporter.increment 'foo.bar', :by => 2
      assert_last_logged 'measure.foo.bar=2'
    end

    def test_increment_supports_source
      @reporter.source = 'sf'

      # default source
      @reporter.increment 'days.foggy'
      assert_last_logged 'measure.days.foggy=1 source=sf'

      # custom source
      @reporter.increment 'days.foggy', :source => 'seattle'
      assert_last_logged 'measure.days.foggy=1 source=seattle'
    end

    def test_measure
      @reporter.measure 'documents.rendered', 12
      assert_last_logged 'measure.documents.rendered=12'

      # custom source
      @reporter.measure 'cycles.wasted', 23, :source => 'cpu_1'
      assert_last_logged 'measure.cycles.wasted=23 source=cpu_1'
    end

    def test_timing
      @reporter.timing('do.stuff') { sleep 0.1 }
      last = last_logged
      assert last =~ /\=/, 'should have a measure pair'
      key, value = last.split('=')
      assert_equal 'measure.do.stuff', key, 'should have timing key'
      assert_in_delta 100, value.to_i, 10

      # custom source
      @reporter.timing('do.more', :source => 'worker') do
        sleep 0.05
      end
      assert last_logged.index('source=worker'), 'should use custom source'
    end

    private

    def assert_last_logged(string)
      assert_equal string, last_logged, "Last logged should be '#{string}'."
    end

    def last_logged
      @buffer.rewind
      @buffer.readlines[-1].to_s.chomp
    end

  end
end