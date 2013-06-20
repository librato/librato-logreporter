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
      assert_equal 'measure.foo=1', last_logged

      @reporter.increment 'foo.bar', :by => 2
      assert_equal 'measure.foo.bar=2', last_logged
    end

    private

    def last_logged
      @buffer.rewind
      @buffer.readlines[-1].chomp
    end

  end
end