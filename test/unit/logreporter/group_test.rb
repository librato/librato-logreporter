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

    end
  end
end