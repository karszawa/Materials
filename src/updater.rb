# -*- coding: utf-8 -*-


# 内部遷移をもつクラス
# @stateに現在の状態を持ち、その名の関数を呼ぶ。
# その状態が最初に呼ばれるときは〜init関数を呼び、終わるときは〜term関数を呼ぶ
class Updater
  def initialize
    @state = :normal
    @first_update = true
  end

  def update
    if @first_update and self.methods.index (@state.to_s + "_init").to_sym
      self.send @state
      @first_update = false
    end

    @tmp = self.send @state

    # 終了処理
    self.send @state.to_s + "_term" if @state != @tmp and
      self.methods.index (@tmp.to_s + "_term").to_sym

    # 初期化処理
    self.send @tmp.to_s + "_init" if @tmp != @state and
      @tmp.class == Symbol and
      self.methods.index (@tmp.to_s + "_init").to_sym

    (@state = @tmp).class == Symbol ? self : @state
  end
end

