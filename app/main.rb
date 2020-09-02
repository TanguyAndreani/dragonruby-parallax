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

def setup args
  Window.set_args args
  Utils.set_args args
  Arrows.set_args args
  Parallax.set_args args

  Window.set_screen_size 1280, 720

  Window.add_lock_line :left, 0, nil
  Window.add_lock_line :right, 1280, nil
  Window.add_lock_line :bottom, nil, 0
  Window.add_lock_line :top, nil, 720

  Window.add name: :root

  Window.add(
    name: :minimap,
    w: 200,
    position: :top_right,
    shrink: true,
    draggable: true,
    focusable: true,
    collision: true,
    margin_left: -10,
    margin_top: 10
  )

  args.state.setup_done = true
end

def tick args
  setup args unless args.state.setup_done

  # Renders the parallax
  Parallax
    .create(layers: LAYERS)
    .update
    .render_into(:root)

  # Renders the arrow keys feedback visual
  Arrows
    .create(size: 200, active_alpha: 50, inactive_alpha: 22)
    .update
    .render_into(:root)

  Window.render :root
  Window.render :minimap, from: :root

  Window.mainloop

  # Just a small helper to display FPS on top of everything
  FPS.render_standalone :debug
end
