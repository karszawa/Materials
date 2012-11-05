
10.times do |i|
  Red 0.5*(i+1), *$conf.rand_point.to_a, 0.5
  Blue 0.5*(i+1), *$conf.rand_point.to_a, 0.5
end

