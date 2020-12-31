#!/usr/bin/env ruby
require_relative '../lib/simply_give.rb'

puts "before"
test = SimplyGive::CLI.new.call
puts "after"
