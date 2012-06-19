require './src/scene'


class Opening < Scene
  def initialize
    super

    @call_me_again_time = 5
  end

  def update
    return Select.new if @call_me_again_time < elapsed_time

    self
  end
end