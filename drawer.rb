# -*- coding: utf-8 -*-
require 'dxruby'


# 課題：描画対象のインスタンス変数が簡単に呼び出せない。
module Drawer
  def self.draw(obj, obj_class = nil)
    begin
      eval "#{obj_class ||= obj.class}.draw obj", @bind ||= binding
    rescue NoMethodError
      if obj_class != Class then draw obj, obj_class.superclass
      else raise "Drawer##{obj_class}#draw is not exist." end
    end
  end


  class DrawProcess; end


  class Opening < DrawProcess
    @font = Font.new 30

    def self.draw(obj)
      Window.draw_font 0, 0, "Now Opening.\nPlease wait #{5 - obj.elapsed_time.floor} seconds.", @font
    end
  end
end


# drawが定義されていないインスタンスはDrawer#DrawProcessクラスで描画される。
class Object
  def draw
    Drawer.draw self
  end
end

