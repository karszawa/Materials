# -*- coding: utf-8 -*-
require 'dxruby'
require './stdlib'

module Drawer
  def self.draw(obj, obj_class = nil)
    begin
      eval "#{obj_class ||= obj.class}.draw obj, obj.pack_all", binding
    rescue ArgumentError # 定義されていなければObject#drawが呼び出されるから
      if obj_class != Class then draw obj, obj_class.superclass
      else raise "Drawer##{obj_class}#draw is not exist." end
    end
  end


  # TODO:サブクラスがインスタンス変数にアクセス出来ない
  class DrawProcess;  end


  class Opening < DrawProcess
    @font = Font.new 30

    def self.draw(obj, args)
      wait_time = args[:call_me_again_time] - obj.elapsed_time.floor
      Window.draw_font 0, 0, "Now Opening... #{wait_time}", @font
    end
  end


  class Select < DrawProcess
    @font = Font.new 20

    def self.draw(obj)
    end
  end
end


# drawが定義されていないインスタンスはDrawer#DrawProcessクラスで描画される。
class Object
  def draw
    Drawer.draw self
  end

  def pack_all
    instances = {}

    instance_variables.each do |inst|
      eval "instances[inst[1..inst.size].to_sym] = #{inst}", binding
    end

    instances
  end
end

