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


class Float
  def to_rad
    self * Math.PI / 180.0
  end

  def to_deg
    self * 180.0 / Math.PI
  end
end


class Array
  # 配列の先頭から走査し条件が真になる要素を取り除く。
  # 偽になる要素が現れた時走査をやめる。
  # また取り除いた要素を返す。
  def delete_heads(&blk)
    ret = []
    self.each do |obj|
      if yield obj then ret << obj
      else break end
    end
    ret
  end

  def delete_heads!(&blk)
    ret = []
    self.reverse!
    self.size.downto 1 do |i|
      if yield self[i-1] then
        ret << self[i-1]
        self.delete_at i-1
      else break end
    end
    self.reverse!
    ret
  end
end


class Vector2
  attr_accessor :x, :y

  def initialize(*args)
    @x = (args[0] ||  0)
    @y = (args[1] || @x)
  end

  def +(other)
    Vector2.new @x + other.x, @y + other.y
  end

  def -@
    Vector2.new -@x, -@y
  end

  def -(other)
    Vector2.new @x - other.x, @y - other.y
  end

  def *(other)
    Vector2.new @x * other, @y * other
  end

  def /(other)
    Vector2.new @x / other, @y / other
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  # 範囲外にｘかｙが出ようとしたら引っかかる
  def self.catch(lower, val, upper)
    Vector2.new range( lower.x, val.x, upper.x ), range( lower.y, val.y, upper.y )
  end

  def self.polar(arg, abs)
    Vector2.new( Math.cos(arg), Math.sin(arg) ) * abs
  end

  def abs
    Math.sqrt(@x**2 + @y**2)
  end

  def arg
    Math.atan2(@y, @x)
  end

  alias :size :abs

  # sizeの大きさに変形する
  def size=(res_size)
    return self if @x == 0 && @y == 0

    ratio = res_size / size

    @x *= ratio
    @y *= ratio
  end

  def rotate(arg)
    self.dup.rotate!(arg)
  end

  def rotate!(arg)
    next_x = @x * Math.cos(arg) - @y * Math.sin(arg)
    next_y = @x * Math.sin(arg) + @y * Math.cos(arg)

    @x = next_x
    @y = next_y

    self
  end

  def to_a
    [@x, @y]
  end
end


Point = Vector2



module Math
  def self.PI; @PI ||= acos(-1); end
end


module Window
  def get_avg_load
    @loads ||= [0]*20
    @loads << get_load
    @loads = @loads[-20..-1]
    @loads.inject(:+) / @loads.size
  end
  module_function :get_avg_load
end

