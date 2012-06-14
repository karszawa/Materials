class Frame
  def initialize
    @start_time = Time.now
  end

  def update
    self
  end

  def elapsed_time
    (Time.new - @start_time).to_f
  end
end
