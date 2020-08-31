class Utils
  def self.set_args args
    @args = args
  end

  def self.distance x1, y1, x2, y2
    if x1 && x2 && y1 && y2
      Math.sqrt((x2-x1).abs**2 + (y2-y1).abs**2)
    elsif x1.nil? || x2.nil?
      (y2-y1).abs
    else
      (x2-x1).abs
    end
  end

  def self.corners **rect
    [
      {x: rect[:x], y: rect[:y]},
      {x: rect[:x]+rect[:w], y: rect[:y]},
      {x: rect[:x], y: rect[:y]+rect[:h]},
      {x: rect[:x]+rect[:w], y: rect[:y]+rect[:h]},
    ]
  end

  def self.mouse_state
    if @args.inputs.mouse.down
      @mouse_state = :down
    elsif @args.inputs.mouse.up
      @mouse_state = :up
    end
    @mouse_state
  end
end
