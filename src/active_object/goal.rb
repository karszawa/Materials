require './src/stdlib'
require './src/active_object/active_object'

class Goal < ActiveObject
  def initialize(x, y, type=:normal)
    super Point.new(x, y), Vector2.new
    @type = type
  end

  def init
    self.collision = [5, 5, 5]
    self.animation_image = [Image.new(10,10).circle(5,5,5,[255,255,255])]
  end
end


