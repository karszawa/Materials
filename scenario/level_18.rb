# -*- coding: utf-8 -*-
75.times do |i|
  arg = i / 75.0 * 2 * Math.PI
  r = 550

  x = r * Math.cos(arg)
  y = r * Math.sin(arg)


  Red 0, x - 225, y, 0.1, follow:true, silver:true
end

75.times do |i|
  arg = i / 75.0 * 2 * Math.PI
  r = 550

  x = r * Math.cos(arg)
  y = r * Math.sin(arg)

  Red 0, x + 225, y, 0.1, follow:true, silver:true
end

Yellow 0, 100, 100, 0.1
Yellow 0, 100, 1400, 0.1
Yellow 0, 1900, 100, 0.1
Yellow 0, 1900, 1400, 0.1
