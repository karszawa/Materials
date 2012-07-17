require './src/updater'

class Scene < Updater
  def initialize
    super
    @start_time = Time.now
  end

  def elapsed_time
    (Time.new - @start_time).to_f
  end
end
