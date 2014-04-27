
50.times do |y|
  Yellow 0, 930, y/50.0*1440, 1.0, silver: true
  Yellow 0, 990, y/50.0*1440, 1.0, silver: true
end

Red 5, 100, 100, 1.0, silver: true
25.times{ |i| Yellow 0, 960+rand(960), rand(1440), rand }

Red 10, 1820, 1320, 1.0, silver: true
25.times{ |i| Yellow 10, rand(960), rand(1440), rand }

