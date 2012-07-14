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

    # Sprite.draw時にはアニメーションが呼ばれるのか
    # アニメーションが設定してある時はアニメーションが再生されて、
    # 普通にdrawが呼ばれると好ましい。
  end

  def update
    move
    fire

    self.x = @point.x
    self.y = @point.y
  end

  def point_out_of_range
    min = $conf[:move_area_min]
    max = $conf[:move_area_max]

    @point.x < min.x || max.x < @point.x || @point.y < min.y || max.y < @point.y
  end

  def move
    @point += @velocity
  end

  def fire; end

  def hit(other)
    self.vanish
  end

  def static_init; end
end

