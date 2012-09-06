require 'dxruby'
require './dxruby/scene'


class GameClearScene
  def init(hash)
    @player = hash[:player]
    @clear_time = hash[:time]
  end
end

class GameOverScene
  def init(hash)
    @enemies = hash[:enemies]
  end
end

