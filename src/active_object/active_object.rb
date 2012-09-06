# -*- coding: utf-8 -*-
require 'dxruby'
require './dxruby/anime_sprite'
require './src/stdlib'


class ActiveObject < AnimeSprite
  attr_reader :life, :point

  def initialize(point, velocity)
    super point.x, point.y, 100

    @point = point
    @velocity = velocity
    @life = 0

    init

    @start_time = Time.now
  end

  def update
    move
    fire

    self.x = @point.x; self.y = @point.y;
  end

  def out(other = nil)
    self.vanish
  end

  def move
    @point += @velocity
  end

  def fire; end

  def hit(other)
    self.vanish
  end

  def init; end

  def draw
    self.x += $conf.draw_gap.x; self.y += $conf.draw_gap.y;

    super

    self.x -= $conf.draw_gap.x; self.y -= $conf.draw_gap.y;
  end
end

