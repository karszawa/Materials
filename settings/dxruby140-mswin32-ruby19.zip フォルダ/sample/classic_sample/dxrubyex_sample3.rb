#!ruby -Ks
# DXRubyExtension�T���v��
require 'dxruby'
require 'dxrubyex'
require './hitrangeview' # �Փ˔���͈͕`�惉�C�u�����BHitRange.view(Collision�z��)�ŏՓ˔���͈͂����F�Ō�����B

class Toufu
  attr_reader :collision, :x, :y

  @@image = Image.new(50,50,[150,150,150])

  def initialize
    @x = rand(590)
    @y = rand(430)
    @dx = rand(2) * 2 - 1
    @dy = rand(2) * 2 - 1

    # collision�I�u�W�F�N�g�Ɏw�肷��l�̓L�����̍����(0,0)�Ƃ����͈�
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

  # �Փˌ��o���ɌĂ΂�郁�\�b�h
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

  # Array#map���g����Toufu�̔z�񂩂�collision�̔z��𐶐�����
  objs = Objects.map { |obj|
    obj.collision
  }

  # collision�z�񓯎m�̏Փ˔���
  Collision.check(objs, objs)

  HitRange.view(objs)
  Objects.each { |obj| obj.draw }

  break if Input.keyPush?(K_ESCAPE)
end
