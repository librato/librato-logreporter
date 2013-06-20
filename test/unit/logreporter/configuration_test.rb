require 'test_helper'
require 'stringio'

module Librato
  class LogReporter
    class ConfigurationTest < MiniTest::Test

      def setup
        @reporter = LogReporter.new
      end

      def test_default_log
        assert_equal $stdout, @reporter.log
      end

      def test_setting_log
        @reporter.log = $stderr
        assert_equal $stderr, @reporter.log
      end

      def test_default_prefix
        assert_equal nil, @reporter.prefix
      end

      def test_setting_prefix
        @reporter.prefix = 'mypref'
        assert_equal 'mypref', @reporter.prefix
      end

      def test_default_source
        assert_equal nil, @reporter.source
      end

      def test_setting_source
        @reporter.source = 'librato'
        assert_equal 'librato', @reporter.source
      end

    end
  end
end