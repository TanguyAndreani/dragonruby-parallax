$gtk.reset

require 'lib/utils.rb'
require 'lib/vector2d.rb'

class Window
  @lockpoints = Hash.new
  @locklines = Hash.new
  @lock_distance = 10

  def self.mainloop
    update_mouse_coords
    update_focus
    update_drag
    move_to_closest_lock { |distance| distance < @lock_distance }
  end

  def self.update_mouse_coords
    @mouse = {
      x: @args.inputs.mouse.x,
      y: @args.inputs.mouse.y
    }
  end

  def self.set_args args
    @args = args
  end

  def self.set_lock_distance n
    @lock_distance = n
  end

  def self.set_screen_size w, h
    @viewport_w = w
    @viewport_h = h
    @viewport_ratio = w/h
  end

  def self.update_focus
    if @args.inputs.mouse.click
      w = window_from_position @mouse
      Window.with(w) do |focused_window|
        if focused_window && focused_window[:focusable]
          @current_focused = focused_window[:name]
          @focused_coords = Vector2d.abs_diff(@mouse, focused_window)
        else
          @current_focused = nil
          @focused_coords = Utils.get_stub(:empty_hash)
        end
      end
    end
    @current_focused
  end

  def self.move_to_closest_lock
    if (@lockpoints.any? || @locklines.any?) && Utils.mouse_state == :down
      Window.with(@current_focused) do |focused_window|
        return if focused_window.nil?

        nearest_lockpoint = nil
        nearest_corner = nil
        acc_distance = nil

        select_lock_proc = proc do |k, v|
          focused_window.corners.each do |_, pt|
            v_distance = Vector2d.distance(pt, v) if nearest_lockpoint
            if !nearest_lockpoint || v_distance < acc_distance
              nearest_lockpoint = v
              nearest_corner = pt
              acc_distance = Vector2d.distance(nearest_corner, nearest_lockpoint)
            end
          end
        end

        @lockpoints.each &select_lock_proc
        @locklines.each &select_lock_proc

        focused_window.move_at({
          x: (nearest_lockpoint[:x] || focused_window[:x]) - (focused_window[:x] - nearest_corner[:x]).abs,
          y: (nearest_lockpoint[:y] || focused_window[:y]) - (focused_window[:y] - nearest_corner[:y]).abs
        }) if block_given? && yield(acc_distance)
      end
    end
  end

  def self.update_drag
    if Utils.mouse_state == :down
      Window.with(@current_focused) do |focused_window|
        if focused_window && focused_window.focusable
          focused_window.move_at Vector2d.diff(@mouse, @focused_coords)
        end
      end
    end
  end

  def self.window_from_position **args
    @windows.each do |k, v|
      if v.focusable && ([args[:x], args[:y]].inside_rect? [v.x, v.y, v.w, v.h])
        return k
      end
    end
    nil
  end

  def self.with name
    if name && @windows[name]
      if block_given?
        yield(@windows[name])
      else
        @windows[name]
      end
    else
      yield(nil)
    end
  end

  def self.add_lock_point name, x, y
    @lockpoints[name] = {x: x, y: y}
  end

  def self.add_lock_line name, x, y
    @locklines[name] = {x: x, y: y}
  end

  def self.render name, from: nil
    @windows[name].render @args, from: from
  end

  def self.render_into name, sprites
    @windows[name].render_into @args, sprites
  end

  def self.top_left name
    [0, @windows[name].h]
  end

  def self.get_size name
    [@windows[name].w, @windows[name].h]
  end

  def self.filter_add_args args

    # default values for width/height

    # viewport size if nothing was provided
    if args[:w].nil? && args[:h].nil?
      args[:w] = @viewport_w
      args[:h] = @viewport_h
    # if either width or height is missing, compute the other based on given
    # ratio, if no ration was provided, use viewport's ratio
    elsif args[:w].nil? && args[:h]
      args[:w] = args[:h] * (args[:ratio] || @viewport_ratio)
    elsif args[:w] && args[:h].nil?
      args[:h] = args[:w] / (args[:ratio] || @viewport_ratio)
    end

    # if `position` was provided, parse it and overwrite x and y
    unless args[:position].nil?
      position = args[:position].to_s.split('_').map(&:to_sym)

      case position[0]
      when :top
        args[:y] = @viewport_h - args[:h]
      when :bottom
        args[:y] = 0
      when :center
        args[:y] = (@viewport_h - args[:h])/2
      end

      case position[1]
      when :right
        args[:x] = @viewport_w - args[:w]
      when :left
        args[:x] = 0
      when :center
        args[:x] = (@viewport_w - args[:w])/2
      end
    end

    # if neither position nor x and y where provided, default to zero
    args[:x] ||= 0
    args[:y] ||= 0

    # we add margins now, but we'll never use them again
    args[:x] += args[:margin_left] if args[:margin_left]
    args[:y] -= args[:margin_top] if args[:margin_top]

    # compute corners coordinates, then updated on each call to move_at()
    args[:corners] = Utils.corners(args)

    # interactions
    args[:focusable] ||= false
    args[:draggable] ||= false
  end

  def self.add **args
    @windows ||= Hash.new
    filter_add_args args
    @windows[args[:name]] = self.new args
    self
  end

  def initialize args
    args.each { |k, v|
      instance_variable_set(:"@#{k}", v)
      Window.send(:attr_reader, k)
    }
    self
  end

  def [](attr)
    instance_variable_get(:"@#{attr}")
  end

  def []=(attr, value)
    instance_variable_set(:"@#{attr}", value)
  end

  def move_at coords
    @x, @y = coords[:x], coords[:y]

    @corners = Utils.corners(self)
  end

  def render_into args, sprites
    args.render_target(@name).primitives << sprites
  end

  def render args, from: nil
    args.outputs.sprites << {
      x: @x,
      y: @y,
      w: w,
      h: h,
      source_w: @shrink ? nil : w,
      source_h: @shrink ? nil : h,
      path: from || @name
    }
  end
end
