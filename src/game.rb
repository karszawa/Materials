# -*- coding: utf-8 -*-
require 'dxruby'
require './dxruby/scene'
require './dxruby/anime_sprite'

require './src/scene/opening'
require './src/scene/play'
require './src/scene/select'
require './src/scene/ranking'
require './src/drawer'


class MaterialsGame < Game
  def run
    Scene.main_loop OpeningScene.new, 60, 1
  end
end

