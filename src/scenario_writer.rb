# -*- coding: utf-8 -*-
require 'ostruct'
require './active_object'


lambda {
  enemies_bench = []

  Kernel.send :define_method, :read_enemies_from_database do |level|
    enemies_bench.clear

    path = "./scenario/level_#{level}.rb"
    load path if File.exist? path

    enemies_bench
  end

  %w[ Red Blue Yellow Green ].each do |name|
    Kernel.send :define_method, name.to_sym do |time, *param|
      obj = OpenStruct.new

      obj.time = time
      obj.enemy = eval "#{name}Enemy.new *param", binding

      enemies_bench << obj
    end
  end
}.call
