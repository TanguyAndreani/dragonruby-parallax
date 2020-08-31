$gtk.reset

class EasingFn
  attr_reader :current

  def initialize from: 0, to: 10, time: 50
    @from = Float from
    @to = Float to
    @time = Float time

    @step = (to - from).abs / time
    @direction = (to > from) ? 1 : -1
    @current = from
  end

  def step! tick_count
    @first_tick ||= tick_count
    diff = tick_count-@first_tick+1
    if diff <= @time
      @current = @from + @step*@direction*diff
    end
    @current
  end

  def reset!
    @first_tick = nil
    @current = @from
  end
end

=begin
a = EasingFn.new(from: 10.0, to: -4.0, time: 10.0)
p a.current

10.times do |tick|
  a.step! tick
  p a.current
end

10.0
8.6
7.2
5.800000000000001
4.4
3.0
1.6000000000000014
0.20000000000000107
-1.1999999999999993
-2.5999999999999996
-4.0
=end
