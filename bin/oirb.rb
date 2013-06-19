#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.require

$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'oirb'

options = { :client => {}, :server => {} }
options[:client][:host] = ARGV.shift || 'beta.ogreisland.com'
options[:client][:port] = ARGV.shift || 5300
options[:server][:host] = ARGV.shift || 'localhost'
options[:server][:port] = ARGV.shift || 5300

EventMachine::run do
  EventMachine::start_server options[:server][:host], options[:server][:port], OgreIsland::Proxy, options[:client]
end
