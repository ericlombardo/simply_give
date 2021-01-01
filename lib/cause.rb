require_relative './simply_give.rb'

class SimplyGive::Cause
  attr_accessor :name, :id

  def initialize(name:, id:)  # using keyword arguments to help future programmers
    @name = name
    @id = id
  end

end