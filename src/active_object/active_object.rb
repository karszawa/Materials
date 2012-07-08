require 'dxruby'
require './src/stdlib'


class ActiveObject
  attr_reader :life, :sprites

  def initialize(point, velocity)
    @point = point
    @velocity = velocity
    @life = 0

    @start_time = Time.now
    @sprites = []
    sprite_init
  end

  def update
    move
    fire
    @sprites.each { |spr| spr.x = @point.x; spr.y = @point.y; }
  end

  def point_out_of_range
    @point.x < $conf[:move_area_min].x || $conf[:move_area_max].x < @point.x || @point.y < $conf[:move_area_min].y || $conf[:move_area_max].y < @point.y
  end

  def move
    @point += @velocity
  end

  def fire; end

  def hit(other)
    @state = :dead
  end

  def sprite_init; end
end

