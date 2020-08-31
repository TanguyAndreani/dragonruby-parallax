$gtk.reset

require 'lib/arrows.rb'
require 'lib/parallax.rb'
require 'lib/window.rb'
require 'lib/fps.rb'

LAYERS = [
  'layer1.png',
  'layer2.png',
  'layer3.png',
  'layer4.png',
  'layer5.png',
].map { |s| "assets/#{s}" }

def checkInput args
  args.state.direction ||= 1

  if args.inputs.keyboard.key_down.left
    args.state.direction = -1
  elsif args.inputs.keyboard.key_down.right
    args.state.direction = 1
  elsif args.inputs.keyboard.key_down.space && !args.state.direction.zero?
    # save direction and stop
    args.state.old_direction = args.state.direction
    args.state.direction = 0
  elsif args.inputs.keyboard.key_down.space
    # restore saved direction
    args.state.direction = args.state.old_direction
  end
end

def setup args
  Window.set_args args
  Utils.set_args args
  Window.set_screen_size 1280, 720
  Window.add_lock_point :somewhere, 200, 200
  Window.add_lock_point :left, 0, nil
  Window.add_lock_point :right, 1280, nil
  Window.add_lock_point :bottom, nil, 0
  Window.add_lock_point :top, nil, 720
  Window.add name: :root

  Window.add(
    name: :minimap,
    w: 200,
    position: :top_right,
    shrink: true,
    draggable: true,
    focusable: true,
    margin_left: -10,
    margin_top: 10
  )

  args.state.setup_done = true
end

def tick args
  setup args unless args.state.setup_done

  # sets args.state.direction
  checkInput args

  # Renders the parallax
  Parallax
    .create(layers: LAYERS)
    .direction(args.state.direction)
    .update
    .render_into(:root)

  # Renders the arrow keys feedback visual
  Arrows
    .create(size: 200, active_alpha: 50, inactive_alpha: 22)
    .update(args.state.tick_count, keys: args.inputs.keyboard.key_down)
    .render_into(:root)

  Window.render :root
  Window.render :minimap, from: :root

  Window.set_focus
  Window.move_window

  # Just a small helper to display FPS on top of everything
  FPS.render_standalone :debug
end
