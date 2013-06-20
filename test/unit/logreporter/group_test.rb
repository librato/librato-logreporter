require 'test_helper'

module Librato
  class LogReporter
    class GroupTest < MiniTest::Test

      def setup
        @reporter = MiniTest::Mock.new
        @group = Group.new(collector: @reporter, prefix: 'mypref')
      end

      def test_increment
        @reporter.expect :increment, true, ['mypref.foo', {}]
        @group.increment 'foo'
        @reporter.verify

        @reporter.expect :increment, true, ['mypref.bar', {:source => 'baz'}]
        @group.increment 'bar', :source => 'baz'
        @reporter.verify
      end

      def test_measure
        @reporter.expect :measure, true, ['mypref.mpg', 52]
        @group.measure 'mpg', 52
        @reporter.verify

        @reporter.expect :measure, true, ['mypref.mpg', 8, {:source => 'vette'}]
        @group.measure 'mpg', 8, :source => 'vette'
        @reporter.verify
      end

      def test_timing
        @reporter.expect :measure, true, ['mypref.completion']
        @group.timing('completion') { sleep 0.01 }
        @reporter.verify
      end

      def test_nesting_group
        @reporter.expect :increment, true, ['mypref.more.foo', {}]
        @group.group :more do |m|
          m.increment :foo
        end
        @reporter.verify
      end

    end
  end
end