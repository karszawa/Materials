require 'dxruby'
require './game'


game = SukkiriShootingGame.new

Window.loop do
  game.update
  game.draw
end

