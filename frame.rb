# -*- coding: utf-8 -*-
require 'dxruby'


# Frameクラス同士は出来るだけ疎結合な関係にする。
# インスタンス間に共通の情報があるのは間違っている。
class Frame
  def initialize
    @start_time = Time.now
  end

  def update; end

  def elapsed_time
    (Time.new - @start_time).to_f
  end
end


class Opening < Frame
  def initialize
    super

    @call_me_again_time = 5
  end

  def update
    return self if elapsed_time < @call_me_again_time

    Select.new
  end
end


class Select < Frame
  def initialize
    super
  end
end


class Play < Frame
  def initialize
    super
  end

end

