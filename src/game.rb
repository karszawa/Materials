# -*- coding: utf-8 -*-
require 'dxruby'
require './src/scene/play'
require './src/drawer'

# 全てのサブクラスは@frameを初期化する必要がある。
class Game
  def update
    @frame = @frame.update
  end

  def draw
    @frame.draw
  end
end


class SukkiriShootingGame < Game
  def initialize
    @frame = Play.new
  end
end

