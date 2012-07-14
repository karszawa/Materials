require 'dxruby'
require 'pry'
require './src/scene/scene.rb'


class Select < Scene
  def initialize
    super

    @now_select = 0
    @str_list = %w[ Play Ranking ]
    @frame_class_list = [ Play, Ranking ]
    @wait = 0.1
    @prev_select_time = Time.now - @wait
  end

  def update
    if @prev_select_time + @wait < Time.now and Input.y != 0 then
      @prev_select_time = Time.now
      @now_select = (@now_select + Input.y) % @str_list.size
    end

    return @frame_class_list[@now_select].new if Input.keyPush?(K_RETURN)

    self
  end
end
