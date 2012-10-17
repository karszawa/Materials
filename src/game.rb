# -*- coding: utf-8 -*-
require 'dxruby'
require './dxruby/scene'
require './dxruby/anime_sprite'
require 'pry'

require './src/scene/opening'
require './src/scene/play'
require './src/scene/select'
require './src/scene/ranking'


class MaterialsGame
  def run
    Scene.main_loop OpeningScene.new, 60, 1
    # Scene.main_loop PlayScene.new, 60, 1
  end
end

