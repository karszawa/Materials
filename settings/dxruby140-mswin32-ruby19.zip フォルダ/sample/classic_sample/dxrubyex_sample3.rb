#!ruby -Ks
# DXRubyExtensionサンプル
require 'dxruby'
require 'dxrubyex'
require './hitrangeview' # 衝突判定範囲描画ライブラリ。HitRange.view(Collision配列)で衝突判定範囲が黄色で見える。

class Toufu
  attr_reader :collision, :x, :y

  @@image = Image.new(50,50,[150,150,150])

  def initialize
    @x = rand(590)
    @y = rand(430)
    @dx = rand(2) * 2 - 1
    @dy = rand(2) * 2 - 1

    # collisionオブジェクトに指定する値はキャラの左上を(0,0)とした範囲
    @collision = CollisionBox.new(self, 0, 0, 49, 49)
  end

  def update
    @x += @dx
    @y += @dy
    @dx = -@dx if @x < 0 or @x > 590
    @dy = -@dy if @y < 0 or @y > 430
    @collision.set(@x, @y)
  end

  def draw
    Window.draw(@x, @y, @@image)
  end

  # 衝突検出時に呼ばれるメソッド
  def hit(obj)
    if (@x - obj.x).abs < (@y - obj.y).abs
      @dy = -@dy
    else
      @dx = -@dx
    end
  end
end

Objects = Array.new(10) { Toufu.new }

Window.loop do
  Objects.each { |obj| obj.update }

  # Array#mapを使ってToufuの配列からcollisionの配列を生成する
  objs = Objects.map { |obj|
    obj.collision
  }

  # collision配列同士の衝突判定
  Collision.check(objs, objs)

  HitRange.view(objs)
  Objects.each { |obj| obj.draw }

  break if Input.keyPush?(K_ESCAPE)
end
