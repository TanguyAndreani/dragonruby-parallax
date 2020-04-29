LAYERS = [
    'layer1.png',
    'layer2.png',
    'layer3.png',
    'layer4.png',
    'layer5.png',
].map { |s| "assets/#{s}" }

def checkInput args
    if args.inputs.keyboard.key_held.left
        args.state.direction = 1
    elsif args.inputs.keyboard.key_held.right
        args.state.direction = -1
    end
end

def tick args
  args.state.direction ||= -1
  args.state.xs ||= LAYERS.map { 0 }

  w = args.grid.right
  h = args.grid.top

  relative_speed = 1.2 # relative speed of a layer
  first_layer_move = 1 # or 0 for 'not moving'

  checkInput args

  LAYERS.each_with_index do |f, layer|
    offset = relative_speed * (layer + first_layer_move)
    offset *= args.state.direction

    args.state.xs[layer] += offset
    x_coord = args.state.xs[layer] % w
    args.outputs.sprites << [
      [x_coord - (w - 1), 0, w, h, f],
      [x_coord, 0, w, h, f],
      [x_coord + (w - 1), 0, w, h, f]
    ]
  end
end