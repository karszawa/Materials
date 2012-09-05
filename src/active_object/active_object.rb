# -*- coding: utf-8 -*-
require 'dxruby'
require './src/stdlib'


class ActiveObject < Sprite
  attr_reader :life, :point

  def initialize(point, velocity)
    super

    @point = point
    @velocity = velocity
    @life = 0

    @start_time = Time.now
    self.static_init
  end

  def update
    move
    fire

    self.x = @point.x
    self.y = @point.y
  end

  def out_of_area
    min = $conf[:move_area_min]
    max = $conf[:move_area_max]

    @point.x < min.x || max.x < @point.x || @point.y < min.y || max.y < @point.y
  end

  def out
    self.vanish
  end

  def move
    @point += @velocity
  end

  def fire; end

  def hit(other)
    self.vanish
  end

  def static_init
    self.x = @point.x
    self.y = @point.y
    self.z = 100
  end
end

