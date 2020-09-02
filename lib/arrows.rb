$gtk.reset

require 'lib/easing.rb'
require 'lib/window.rb'

class Arrows
  SPRITE = 'assets/arrow.png'

  def self.set_args args
    @args = args
  end

  # singleton pattern
  def self.create *args
    @instance ||= self.new *args
    self
  end

  def self.update
    @instance.update @args
    self
  end

  def self.render_into win
    @instance.render_into win
    self
  end

  def initialize w: 1280, h: 720, size: 100, margin: 10, inactive_alpha: 10, active_alpha: 30
    @easings = {
      left: EasingFn.new(from: active_alpha, to: inactive_alpha, time: 50),
      right: EasingFn.new(from: active_alpha, to: inactive_alpha, time: 50)
    }

    @arrows = {
      left: {
        w: size,
        h: size,
        x: margin,
        y: h/2 - size/2,
        path: SPRITE,
        flip_horizontally: true,
        a: inactive_alpha
      }.sprite,
      right: {
        w: size,
        h: size,
        x: w - size - margin,
        y: h/2 - size/2,
        path: SPRITE,
        a: inactive_alpha
      }.sprite,
    }
    # so that we don't have to call it every time in Arrows#render
    @sprites = @arrows.values
  end

  def update args
    tick_count = args.state.tick_count
    keys = args.inputs.keyboard.key_down
    [:left, :right].each do |sy|
      if keys.send(sy)
        @easings[sy].reset!
      end
      @easings[sy].step! tick_count
      @arrows[sy][:a] = @easings[sy].current
    end
    self
  end

  def render_into win
    Window.render_into win, @sprites # == @arrows.values
    self
  end
end
