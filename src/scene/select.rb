require 'dxruby'
require './src/scene.rb'


class Select < Scene
  def initialize
    super

    @now_select = 0
    @str_list = %w[ Play Ranking ]
    @frame_class_list = [ Play, Ranking ]
  end

  def update
    @now_select = (@now_select + Input.y) % @str_list.size

    if Input.keyPush?(K_RETURN) then return @frame_class_list[@now_select].new end

    self
  end
end
