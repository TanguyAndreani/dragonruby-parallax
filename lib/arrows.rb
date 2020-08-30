require 'lib/easing.rb'

class Arrows
  SPRITE = 'assets/arrow.png'

  # singleton pattern
  def self.create *args
    @@instance ||= self.new *args
    @@instance
  end

  def initialize w: 1280, h: 720, size: 100, margin: 10, inactive_alpha: 10, active_alpha: 30
    @inactive_alpha = inactive_alpha
    @active_alpha = active_alpha
    @easings = {
      left: EasingFn.new(from: @active_alpha, to: @inactive_alpha, time: 50),
      right: EasingFn.new(from: @active_alpha, to: @inactive_alpha, time: 50)
    }
    @arrows = {
      left: {
        w: size,
        h: size,
        x: margin,
        y: h/2 - size/2,
        path: SPRITE,
        flip_horizontally: true,
        a: @inactive_alpha
      }.sprite,
      right: {
        w: size,
        h: size,
        x: w - size - margin,
        y: h/2 - size/2,
        path: SPRITE,
        a: @inactive_alpha
      }.sprite,
    }
    # so that we don't have to call it every time in Arrows#render
    @sprites = @arrows.values
  end

  # imitates args.inputs.keyboard.key_*
  DEFAULT_KEYS = Struct.new(:left, :right).new(nil, nil)

  def update tick_count, keys: DEFAULT_KEYS
    [:left, :right].each do |sy|
      if keys.send(sy)
        @easings[sy].reset!
      end
      @easings[sy].step! tick_count
      @arrows[sy][:a] = @easings[sy].current
    end
    self
  end

  def render args, win
    win.render_into args, @sprites # == @arrows.values
  end
end
