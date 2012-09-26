require './src/stdlib'
require './src/active_object/active_object'

class Goal < ActiveObject
  def initialize(x, y, type)
    super Point.new(x, y), Vector2.new
  end

  
end

