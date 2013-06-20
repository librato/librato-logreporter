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
      @reporter.increment 'days.foggy'
      assert_last_logged 'measure.days.foggy=1 source=sf'
    end

    private

    def assert_last_logged(string)
      assert_equal string, last_logged, "Last logged should be '#{string}'."
    end

    def last_logged
      @buffer.rewind
      @buffer.readlines[-1].chomp
    end

  end
end