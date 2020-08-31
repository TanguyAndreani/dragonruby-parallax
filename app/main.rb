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
  Window.add name: :root

  minimap_relative_size = 0.2

  Window.add(
    name: :minimap,
    x: 1280-1280*minimap_relative_size,
    y: 720-720*minimap_relative_size,
    w: 1280*minimap_relative_size,
    h: 720*minimap_relative_size,
    shrink: true,
    draggable: true
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

  # Just a small helper to display FPS on top of everything
  FPS.render_standalone :debug
end
