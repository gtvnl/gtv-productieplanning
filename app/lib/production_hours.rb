class ProductionHours

  attr_accessor :hours
  attr_accessor :minutes
  attr_accessor :seconds

  def initialize(val)
    @hours = val.split(":")[0].to_i
    @minutes = val.split(":")[1].to_i
    @seconds = val.split(":")[2].to_i
  end

  # def to_minutes
  #   minutes = (@hours * 60) + @minutes + (@seconds / 60)
  #   seconds = @seconds % 60
  #   "#{minutes}:#{seconds}"
  # end

  def to_seconds
    (@hours * 3600) + (@minutes * 60) + @seconds
  end



end
