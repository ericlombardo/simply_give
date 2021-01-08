require "bundler/setup"

# require gems first
require 'colorize'
require 'pry'
# require models
require_relative './api_keys.rb'
require_relative "./simply_give/version"
require_relative './cli.rb'
require_relative './api.rb'
require_relative './project.rb'
require_relative './cause.rb'
require_relative './charity.rb'

# require modules
module SimplyGive
  class Error < StandardError; end
  # Your code goes here...
end

