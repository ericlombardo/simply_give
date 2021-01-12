class SimplyGive::Cause
  attr_accessor :id, :name

  @@all = []
  def initialize(id:, name:)  # takes in 'id' and 'name'
    @id = id
    @name = name
    @projects = []  # creates an empty projects array to push future projects in
    save
  end

  def self.all   # getter method for all array
    @@all
  end
  
  def save       # saves instance to all array
    self.class.all << self
  end
end

