# -*- coding: utf-8 -*-
require 'dxruby'
require 'dxrubyex'

require './src/stdlib'
require './src/hitrangeview'
require './src/active_object/player'

def hit_range_view(collisions, point)
  return unless $conf[:debug]

  collisions.each { |obj| obj.set *(point + $conf[:draw_gap]).to_a }
  HitRange.view collisions
  collisions.each { |obj| obj.set *point.to_a }
end


module Drawer
  def self.draw(obj, obj_class = nil)
    return if obj.class.to_s == "Bullet" and obj.class.superclass == ActiveObject

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

    def self.draw(obj, args)
      base_x = 150; base_y = 100

      args[:str_list].each_with_index do |name, idx|
        dx = (args[:now_select] == idx ? -50 : 0)
        Window.draw_font base_x + dx, base_y += 50, name, @font
      end
    end
  end


  class HUD < DrawProcess
    @font = Font.new 20
    @image = Image.load('./img/play_background.png')

    def self.draw(obj, args)
      # player life
      # rest enemies
      # hiscore

      Window.draw *($conf[:draw_gap].to_a), @image, 0

      Window.draw_font 0, 0, args[:scene].size.to_s, @font
    end
  end

  class Player < DrawProcess
    @image = Image.load('./img/blue_enemy.png')

    def self.draw(obj, args)
      Window.draw *(args[:point] + $conf[:draw_gap]).to_a, @image, 100

      hit_range_view args[:collisions], args[:point]
    end
  end


  class Bullet < DrawProcess
    @image = Image.load('./img/red_enemy.png')

    def self.draw(obj, args)
      Window.draw *(args[:point] + $conf[:draw_gap]).to_a, @image, 100

      hit_range_view args[:collisions], args[:point]
    end
  end


  class RedEnemy < DrawProcess
    @image = Image.load('./img/red_enemy.png')

    def self.draw(obj, args)
      Window.draw *(args[:point] + $conf[:draw_gap]).to_a, @image, 100

      hit_range_view args[:collisions], args[:point]
    end
  end


  class BlueEnemy < DrawProcess
    @image = Image.load('./img/blue_enemy.png')

    def self.draw(obj, args)
      Window.draw *(args[:point] + $conf[:draw_gap]).to_a, @image, 100

      hit_range_view args[:collisions], args[:point]
    end
  end


  class YellowEnemy < DrawProcess
    @image = Image.load('./img/yellow_enemy.png')

    def self.draw(obj, args)
      Window.draw *(args[:point] + $conf[:draw_gap]).to_a, @image, 100

      hit_range_view args[:collisions], args[:point]
    end
  end

  class GreenEnemy < DrawProcess
    @image = Image.load('./img/green_enemy.png')

    def self.draw(obj, args)
      Window.draw *(args[:point] + $conf[:draw_gap]).to_a, @image, 100

      hit_range_view args[:collisions], args[:point]
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

