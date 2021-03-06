librato-logreporter
=======

[![Gem Version](https://badge.fury.io/rb/librato-logreporter.png)](http://badge.fury.io/rb/librato-logreporter) [![Build Status](https://secure.travis-ci.org/librato/librato-logreporter.png?branch=master)](http://travis-ci.org/librato/librato-logreporter) [![Code Climate](https://codeclimate.com/github/librato/librato-logreporter.png)](https://codeclimate.com/github/librato/librato-logreporter)

`librato-logreporter` provides an easy interface to write metrics ultimately bound for [Librato Metrics](https://metrics.librato.com/) to your logs or another IO stream. It is fully format-compliant with [l2met](https://github.com/ryandotsmith/l2met). If you are running on Heroku it will allow you to easily insert metrics which can be retrieved via a [log drain](https://devcenter.heroku.com/articles/logging#syslog-drains).

NOTE: Current versions of this library use the [logging conventions](https://github.com/ryandotsmith/l2met/wiki/Usage) established in l2met 2.0 and greater. For use with [older versions](https://github.com/ryandotsmith/l2met/wiki/Usage) of l2met, use v0.1 of this gem.

This library is ideally suited for custom or short-lived processes where the overhead of in-process collection will be costly and external metric collectors are unavailable.

If you are considering using `librato-logreporter` for a rails or rack-based web app, first explore [librato-rails](https://github.com/librato/librato-rails) and/or [librato-rack](https://github.com/librato/librato-rack). In most cases one of these libraries will be a better solution for your web applications.

Currently Ruby 1.9.2+ is required.

## Quick Start

Install `librato-logreporter` in your application:

    require 'librato/logreporter'

You can now track custom metrics by adding simple one-liners to your code:

    # keep counts of key events
    Librato.increment 'jobs.worked'

    # benchmark sections of code to verify performance
    Librato.timing 'my.complicated.work' do
      # do work
    end

    # track averages across processes/jobs/requests
    Librato.measure 'payload.size', payload.length_in_bytes

## Installation & Configuration

Install the gem:

    $ gem install librato-logreporter

Or add to your Gemfile if using bundler:

    gem "librato-logreporter"

Then require it:

    require 'librato-reporter'

If you don't have a [Librato Metrics](https://metrics.librato.com/) account already, [sign up](https://metrics.librato.com/). In order to send measurements to Librato you will need to provide your account credentials to the processor for output from `librato-reporter`.

##### Environment variables

There are a few optional environment variables you may find useful:

* `LIBRATO_SOURCE` - the default source to use for submitted metrics. If not set your metrics will be submitted without a source.
* `LIBRATO_PREFIX` - a prefix which will be prepended to all metric names

##### Running on Heroku

You should specify a custom source for your app to track properly. You can set the source in your environment:

    heroku config:add LIBRATO_SOURCE=myappname

NOTE: if Heroku idles your process no measurements will be sent until it receives a request and is restarted. If you see intermittent gaps in your measurements during periods of low traffic this is the most likely cause.

##### Silencing Output

If you would like to turn off logging to StdOut, for example, in your local environment, you can add the following after `require 'librato-reporter'` to send output to /dev/null:

    Librato.log_reporter.log = File.open(File::NULL, "w")

##### Harvesting your metrics from your logs

There are few options for this which we will document further going forward. For the moment, [come ask us about it](http://chat.librato.com/).

## Custom Measurements

Tracking anything that interests you is easy with Librato. There are four primary helpers available:

#### increment

Use for tracking a running total of something _across_ jobs or requests, examples:

    # increment the 'jobs.completed' metric by one
    Librato.increment 'jobs.completed'

    # increment by five
    Librato.increment 'items.purchased', :by => 5

    # increment with a custom source
    Librato.increment 'user.purchases', :source => user.id

Other things you might track this way: user activity, requests of a certain type or to a certain route, total jobs queued or processed, emails sent or received

#### measure

Use when you want to track an average value _per_-measurement period. Examples:

    Librato.measure 'payload.size', 212

    # report from a custom source
    Librato.measure 'jobs.by.user', 3, :source => job.requestor.id

#### timing

Like `Librato.measure` this is per-period, but specialized for timing information:

    Librato.timing 'twitter.lookup.time', 21.2

The block form auto-submits the time it took for its contents to execute as the measurement value:

    Librato.timing 'twitter.lookup.time' do
      @twitter = Twitter.lookup(user)
    end

#### group

There is also a grouping helper, to make managing nested metrics easier. So this:

    Librato.measure 'memcached.gets', 20
    Librato.measure 'memcached.sets', 2
    Librato.measure 'memcached.hits', 18

Can also be written as:

    Librato.group 'memcached' do |g|
      g.measure 'gets', 20
      g.measure 'sets', 2
      g.measure 'hits', 18
    end

Symbols can be used interchangeably with strings for metric names.

## Contribution

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project and submit a pull request from a feature or bugfix branch.
* Please include tests. This is important so we don't break your changes unintentionally in a future version.
* Please don't modify the gemspec, Rakefile, version, or changelog. If you do change these files, please isolate a separate commit so we can cherry-pick around it.

## Copyright

Copyright (c) 2013 [Librato Inc.](http://librato.com) See LICENSE for details.
