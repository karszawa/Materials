# -*- coding: utf-8 -*-
require 'dxruby'
require './dxruby/scene'
require './dxruby/anime_sprite'
require './dxruby/round_box'

require './src/conf'
require 'pry' if $conf.debug

require './src/scene/opening'
require './src/scene/play'
require './src/scene/select'
require './src/scene/ranking'


class MaterialsGame
  def run
    Scene.main_loop SelectScene.new, 60, 1
    # Scene.main_loop PlayScene.new, 60, 1
  end
end

