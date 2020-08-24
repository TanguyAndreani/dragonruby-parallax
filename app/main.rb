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
    if args.inputs.keyboard.key_held.left
        args.state.direction = -1
    elsif args.inputs.keyboard.key_held.right
        args.state.direction = 1
    end
end

def tick args
  args.state.direction ||= 1

  checkInput args

  args.outputs.primitives << [
    Parallax.create(layers: LAYERS).direction(args.state.direction).render,
    Arrows.create(size: 200).render(key_held: args.inputs.keyboard.key_held)
  ]
end
