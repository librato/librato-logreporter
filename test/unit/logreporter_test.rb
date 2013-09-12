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
      assert_last_logged 'count#foo=1'

      @reporter.increment 'foo.bar', :by => 2
      assert_last_logged 'count#foo.bar=2'
    end

    def test_increment_supports_source
      @reporter.source = 'sf'

      # default source
      @reporter.increment 'days.foggy'
      assert_last_logged 'count#days.foggy=1 source=sf'

      # custom source
      @reporter.increment 'days.foggy', :source => 'seattle'
      assert_last_logged 'count#days.foggy=1 source=seattle'
    end

    def test_measure
      @reporter.measure 'documents.rendered', 12
      assert_last_logged 'measure#documents.rendered=12'

      # custom source
      @reporter.measure 'cycles.wasted', 23, :source => 'cpu_1'
      assert_last_logged 'measure#cycles.wasted=23 source=cpu_1'
    end

    def test_timing
      @reporter.timing('do.stuff') { sleep 0.1 }
      last = last_logged
      assert last =~ /\=/, 'should have a measure pair'
      key, value = last.split('=')
      assert_equal 'measure#do.stuff', key, 'should have timing key'
      assert_in_delta 100, value.to_i, 10

      # custom source
      @reporter.timing('do.more', :source => 'worker') do
        sleep 0.05
      end
      assert last_logged.index('source=worker'), 'should use custom source'
    end

    def test_basic_grouping
      @reporter.group :pages do |p|
        p.increment :total
        p.timing :render_time, 63
        # nested
        p.group('public') { |pub| pub.increment 'views', :by => 2 }
      end

      @buffer.rewind
      lines = @buffer.readlines
      assert_equal 'count#pages.total=1', lines[0].chomp
      assert_equal 'measure#pages.render_time=63', lines[1].chomp
      assert_equal 'count#pages.public.views=2', lines[2].chomp
    end

    def test_custom_prefix
      @reporter.prefix = 'librato'

      # increment
      @reporter.increment 'views'
      assert_last_logged 'count#librato.views=1'

      # measure/timing
      @reporter.measure 'sql.queries', 6
      assert_last_logged 'measure#librato.sql.queries=6'

      # group
      @reporter.group :private do |priv|
        priv.increment 'secret'
      end
      assert_last_logged 'count#librato.private.secret=1'
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