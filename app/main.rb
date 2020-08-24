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
    if args.inputs.keyboard.key_down.left
        args.state.direction = -1
    elsif args.inputs.keyboard.key_down.right
        args.state.direction = 1
    elsif args.inputs.keyboard.key_down.space && !args.state.direction.zero?
        args.state.old_direction = args.state.direction
        args.state.direction = 0
    elsif args.inputs.keyboard.key_down.space
        args.state.direction = args.state.old_direction
    end
end

def tick args
  args.state.direction ||= 1

  checkInput args

  args.outputs.primitives << [
    Parallax.create(layers: LAYERS).direction(args.state.direction).render,
    Arrows.create(size: 200, active_alpha: 50, inactive_alpha: 22).render(args.state.tick_count, keys: args.inputs.keyboard.key_down)
  ]
end
