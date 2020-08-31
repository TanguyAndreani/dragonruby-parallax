$gtk.reset

require 'lib/utils.rb'

class Window
  def self.set_args args
    @args = args
  end

  def self.set_screen_size w, h
    @viewport_w = w
    @viewport_h = h
    @viewport_ratio = Float(w).fdiv(h)
  end

  def self.set_focus
    if @args.inputs.mouse.down
      @current_focused = window_from_position @args.inputs.mouse.down.x, @args.inputs.mouse.down.y
      @focused_coordinaates = if @current_focused
        { x: (@args.inputs.mouse.down.x - @windows[@current_focused].x).abs,
          y: (@args.inputs.mouse.down.y - @windows[@current_focused].y).abs }
      else
        { x: 0, y: 0 }
      end
    end
    @current_focused.name
  end

  def self.move_window
    curr = @windows[@current_focused]
    if Utils.mouse_state == :down && curr && curr.focusable
      curr.move_at @args.inputs.mouse.x - @focused_coordinaates[:x], @args.inputs.mouse.y - @focused_coordinaates[:y]


      if @lockpoints
        nearest_lockpoint = nil
        corner = nil
        acc_distance = nil

        @lockpoints.each do |k, v|
          Utils.corners(curr.rect).each do |pt|
            if !nearest_lockpoint.nil?
              v_distance = Utils.distance(pt[:x], pt[:y], v[:x], v[:y])
              acc_distance = Utils.distance(corner[:x], corner[:y], nearest_lockpoint[:x], nearest_lockpoint[:y])
            end
            if nearest_lockpoint.nil? || v_distance < acc_distance
              nearest_lockpoint = v
              corner = pt
            end
          end
        end

        if nearest_lockpoint
          newpos = { x: (nearest_lockpoint[:x] || curr.x) - (curr.x - corner[:x]).abs,
                     y: (nearest_lockpoint[:y] || curr.y) - (curr.y - corner[:y]).abs }
          curr.move_at newpos[:x], newpos[:y] if acc_distance < 50
        end
      end
    end
    @current_focused
  end

  def self.window_from_position x, y
    @windows.reverse_each do |k, v|
      if v.focusable && ([x, y].inside_rect? [v.x, v.y, v.w, v.h])
        return v.name
      end
    end
    nil
  end

  def self.with name
    @windows[name]
  end

  def self.add_lock_point name, x, y
    @lockpoints ||= Hash.new
    @lockpoints[name] = {x: x, y: y}
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

  def self.add **args
    @windows ||= Hash.new

    if args[:w].nil? && args[:h].nil?
      args[:w] = @viewport_w
      args[:h] = @viewport_h
    elsif args[:w].nil? && args[:h]
      args[:w] = args[:h] * (args[:ratio] || @viewport_ratio)
    elsif args[:w] && args[:h].nil?
      args[:h] = args[:w] / (args[:ratio] || @viewport_ratio)
    end

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

    args[:x] ||= 0
    args[:y] ||= 0

    args[:focusable] ||= false

    args[:moved_once] = false

    args[:rect] = {
      x: args[:x],
      y: args[:y],
      w: args[:w],
      h: args[:h]
    }

    args[:x] += args[:margin_left] if args[:margin_left]
    args[:y] -= args[:margin_top] if args[:margin_top]

    @windows[args[:name]] = self.new args
  end

  def initialize **args
    args.each { |k, v|
      instance_variable_set("@#{k}", v)
      Window.send(:attr_reader, k)
    }
    self
  end

  def move_at x, y
    @moved_once = true
    @rect[:x], @rect[:y] = x, y
    @x, @y = x, y
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
