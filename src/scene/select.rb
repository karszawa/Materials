# -*- coding: undecided -*-
require 'dxruby'
require 'pry' if $conf.debug
require './dxruby/scene'


class SelectScene < Scene::Base
  def init
    @now_choice = 0
    @choices_list = %w[ Play Ranking ]
    @scene_list = [ PlayScene, RankingScene ]
    @weight = 0.1
    @free_time = Time.now - @weight
  end

  def update
    if @free_time < Time.now and Input.y != 0 then
      @free_time = Time.now + @weight
      @now_choice = (@now_choice + Input.y) % @choices_list.size
    end

    if Input.key_push?(K_RETURN) or Input.key_push?(K_Z)
      @next_scene = @scene_list[@now_choice].new
    end
  end

  @@font = Font.new 30
  def render
    base_x = 150; base_y = 100;

    @choices_list.each_with_index do |name, idx|
      dx = (@now_choice == idx ? -50 : 0)

      Window.draw_font(base_x + dx, base_y += 50, name, @@font)
    end
  end
end
