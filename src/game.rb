# -*- coding: utf-8 -*-
require 'dxruby'
require './src/scene/opening'
require './src/scene/play'
require './src/scene/select'
require './src/scene/ranking'
require './src/drawer'

# 全てのサブクラスは@frameを初期化する必要がある。
class Game
  def update
    @frame = @frame.update
  end

  def draw
    @frame.draw
  end

  def run
    Window.loop do
      self.update
      self.draw
    end
  end
end


class MaterialsGame < Game
  def initialize
    @frame = Play.new
    # @frame = Opening.new
  end
end

