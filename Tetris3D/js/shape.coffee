window.Tetris = {}

class Tetris.Shape
  constructor: (points) ->
    @blocks = points.map ([x, y, z]) -> new Tetris.Block x, y, z
    @position =
      x: 0
      y: 0
      z: 0

  draw: ->
    @blocks.forEach (b) ->
      b.draw()

  erase: ->
    @blocks.forEach (b) ->
      b.erase()

  move: (diffx, diffy, diffz) ->
    @blocks.forEach (b) ->
      b.x += diffx
      b.y += diffy
      b.z += diffz
      b.calculate_pos()

  set_position: (posx, posy, posz) ->
    @position.x = posx
    @position.y = posy
    @position.z = posz
    @blocks.forEach (b) ->
      b.x += posx
      b.y += posy
      b.z += posz
      b.calculate_pos()

  rotate: (dirx, diry, dirz) ->
    position = @position
    unless dirx == 0
      @blocks.forEach (b) ->
        temp = b.y
        b.y = (-(b.z - position.z)) * dirx + position.y
        b.z = (temp - position.y) * dirx + position.z
        b.calculate_pos()

    unless diry == 0
      @blocks.forEach (b) ->
        temp = b.x
        b.x = (b.z - position.z) * diry + position.x
        b.z = (-(temp - position.x)) * diry + position.z
        b.calculate_pos()

    unless dirz == 0
      @blocks.forEach (b) ->
        temp = b.x
        b.x = (-(b.y - position.y)) * dirz + position.x
        b.y = (temp - position.x) * dirz + position.y
        b.calculate_pos()

  check_col: ->
    reboot = false
    @blocks.forEach (b) ->
      # check if reached a static block

      # check if reached the minimum level
      if b.z <= 0
        reboot = true
    if reboot
      instantiate_shape()
      @erase()
    @move(0, 0, -1)