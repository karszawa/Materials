# -*- coding: utf-8 -*-
require 'ostruct'
require './src/active_object/enemy'


def puts_enemies_arong_wall(a, b, type, difficulty)
  if b < a then
    puts_enemies_arong_wall(0, a, type, difficulty)
    puts_enemies_arong_wall(b, @@conf[:max_divid_wall], type, difficulty)
  else
    for i in a..b do

    end
  end
end


lambda {
  enemies_bench = []

  Kernel.send :define_method, :read_enemies_from_database do |level|
    enemies_bench.clear

    path = "./scenario/level_#{level}.rb"
    load path if File.exist? path

    enemies_bench.sort { |a, b| b.time <=> a.time }
  end

  # シンボルの配列作るのはないのかな？
  %w[ Red Blue Yellow Green ].each do |name|
    Kernel.send :define_method, name.to_sym do |time, *param|
      obj = OpenStruct.new

      obj.time = time

      # いちいちScenario側でPoint.newするのが面倒くさいから。
      point = Point.new( param[0], param[1] )
      obj.enemy = eval "#{name}Enemy.new point, *param[2..param.size]", binding

      enemies_bench << obj
    end
  end
}.call
