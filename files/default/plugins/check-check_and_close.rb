#!/usr/bin/env ruby

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/check/cli'
require 'batsd'

class CheckCheckAndClose < Sensu::Plugin::Check::CLI
  option :warn, :short => '-w VALUE'
  option :crit, :short => '-c VALUE'

  def run
    total = error_check(Time.now - 720).to_i
    critical if total < config[:crit]
    warning  if total < config[:warn]
    ok
  end

  def error_check(t2, t1 = Time.now)
    b = Batsd.new(:host => '127.0.0.1')
    b.values('counters:check_and_close_exception', t2, t1).reduce(:+)
  end
end
