require 'dxruby'
require './dxruby/scene'
require './src/play'

class GameClearScene < ActiveSceneBase
  def initialize(args)
    super args
  end

  def init(args)
    super args

    @panel = DynamicMessagePanel.new(:gameclear)
  end

  def update
    super

    if (Input.key_push?(K_Z) and 1 < self.elap_time) or 5 < self.elap_time
      @next_scene = RankingScene.new(life: @player.life)
    end
  end
end

class GameOverScene < ActiveSceneBase
  def initialize(args)
    super args
  end

  def init(args)
    super args

    @panel = DynamicMessagePanel.new(:gameover)
  end

  def update
    super

    if (Input.key_push?(K_Z) and 1 < self.elap_time) or 5 < self.elap_time
      @next_scene = RankingScene.new(level: @level)
    end
  end
end

