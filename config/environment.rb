require "bundler/setup"

# require gems first
require 'colorize'
require 'pry'
# require models
require_relative '../lib/api_keys.rb'
require_relative "../lib/concerns/version"
require_relative '../lib/cli.rb'
require_relative '../lib/api.rb'
require_relative '../lib/project.rb'
require_relative '../lib/cause.rb'
require_relative '../lib/charity.rb'

# require modules
module SimplyGive
  class Error < StandardError; end
  # Your code goes here...
end
