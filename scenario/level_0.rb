# -*- coding: utf-8 -*-

time = 1
point_x = rand 1000
point_y = rand 500
difficulty = rand

Red time, point_x, point_y, difficulty
Blue time, point_x, point_y, difficulty
Green time, point_x, point_y, difficulty
Yellow time, point_x, point_y, difficulty

Red time, point_x+1000, point_y+1000, difficulty, silver:true
Blue time, point_x+1000, point_y+1000, difficulty, silver:true
Green time, point_x+1000, point_y+1000, difficulty, silver:true
Yellow time, point_x+1000, point_y+1000, difficulty, silver:true

5.times do |t|
  10.times do |i|
    arg = i / 10.0 * 2 * Math.PI
    r = 200

    x = r * Math.cos(arg)
    y = r * Math.sin(arg)

    # メソッドの最後にfallow:trueを追加で、出現位置をプレイヤー基準にする。
    Red 5 + t, x, y, 0.5 + t * 0.1, follow:true
  end
end
