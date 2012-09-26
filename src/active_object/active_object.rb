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
    super

    if fighting?
      move
      fire

      self.x = @point.x; self.y = @point.y;
    end
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
    self.x -= self.image.width/2; self.y -= self.image.height/2;

    super

    self.x -= $conf.draw_gap.x; self.y -= $conf.draw_gap.y;
    self.x += self.image.width/2; self.y += self.image.height/2;
  end

  def fighting?
    self.collision_enable
  end

  def fighting=(val)
    self.collision_enable = val
  end

  def start_animation(v, __animation_image=nil, animation_pattern=nil, nxt=nil)
    self.animation_image = __animation_image if __animation_image

    super v, animation_pattern, nxt
  end
end

