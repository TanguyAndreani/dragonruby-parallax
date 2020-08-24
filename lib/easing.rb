class EasingFn
  attr_reader :current

  def initialize from: 0, to: 10, time: 50
    @from = from
    @to = to
    @time = time
    @step = (to - from).abs / time
    @direction = (to > from) ? 1 : -1
    @current = from
  end

  def step! tick_count
    @first_tick ||= tick_count
    if tick_count-@first_tick < @time
      @current = @from + @step*@direction*(tick_count-@first_tick)
    end
  end

  def reset!
    @first_tick = nil
    @current = @from
  end
end
