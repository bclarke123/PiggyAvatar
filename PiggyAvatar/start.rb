#!/usr/bin/env ruby 

require 'rubygems'
require 'rack'
require 'piggy_generator'

Rack::Handler::WEBrick.run proc {|env| PiggyGenerator.process! env } , :Port => 9292
