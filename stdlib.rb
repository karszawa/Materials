# -*- coding: utf-8 -*-

class Object
  def eigenclass
    class << self; self; end
  end
end


def max(*args)
  res = args[0]
  args.each{ |val| res = val if res < val }
  res
end


def min(*args)
  res = args[0]
  args.each{ |val| res = val if val < res }
  res
end


def range(lower, val, upper)
  max(lower, min(val, upper))
end


class Vector2
  attr_reader :x, :y

  def initialize(*args)
    @x = (args[0] || 0)
    @y = (args[1] || 0)
  end

  def +(other)
    Vector2.new @x + other.x, @y + other.y
  end

  def -(other)
    Vector2.new @x - other.x, @y - other.y
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  # 範囲外にｘかｙが出ようとしたら引っかかる
  def self.catch(lower, val, upper)
    Vector2.new range( lower.x, val.x, upper.y ), range( lower.y, val.y, upper.y )
  end

  def size
    Math.sqrt @x**2 + @y**2
  end

  # sizeの大きさに変形する
  def size=(res_size)
    return self if @x == 0 && @y == 0

    ratio = res_size / size

    @x *= ratio
    @y *= ratio

    self
  end
end


Point = Vector2

