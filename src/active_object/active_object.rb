require 'dxruby'
require './src/stdlib'


class ActiveObject
  attr_reader :life, :collisions

  def initialize(point, velocity)
    @point = point; @velocity = velocity

    @life = 0
    @collisions = []

    @state = :apper
    @start_time = Time.now
    # @arrive_time = 1

    @arrive_time = 0
  end

  def update
    @state = :active if @state != :active && @arrive_time < Time.now - @start_time

    if @state == :active then
      move
      fire
      collisions.each { |obj| obj.set @point.x, @point.y }
    end
  end

  def point_out_of_range
    (@point.x < $conf[:move_area_min].x || $conf[:move_area_max].x < @point.x) ||
      (@point.y < $conf[:move_area_min].y || $conf[:move_area_max].y < @point.y)
  end

  def move; end
  def fire; end

  def hit(other)
    @state = :dead
  end
end

