require 'lib/arrows.rb'
require 'lib/parallax.rb'

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

def tick args
  # sets args.state.direction
  checkInput args

  args.outputs.primitives << [
    # Renders the parallax
    Parallax
    .create(layers: LAYERS)
    .direction(args.state.direction)
    .render,

    # Renders the arrow keys feedback visual
    Arrows
    .create(size: 200, active_alpha: 50, inactive_alpha: 22)
    .render(args.state.tick_count, keys: args.inputs.keyboard.key_down)
  ]
end
