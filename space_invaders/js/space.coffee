BLOCK_SIZE = 3
WIDTH_BLOCKS = 232
HEIGHT_BLOCKS = 148
WIDTH = WIDTH_BLOCKS * BLOCK_SIZE
HEIGHT = HEIGHT_BLOCKS * BLOCK_SIZE

stage = new Kinetic.Stage({
  container: "container"
  width: WIDTH
  height: HEIGHT
})

# Drawing the black background rectangle
backgroundLayer = new Kinetic.Layer();

backgroundRect = new Kinetic.Rect({
  x: 0
  y: 0
  width: WIDTH
  height: HEIGHT
  fill: "#000000"
})

backgroundLayer.add(backgroundRect)

stage.add(backgroundLayer)

class SquaryObject
  constructor: (@x, @y, @color, @pos1, @pos2) ->
    @firstAnim = true
    @squareSeq = @pos1

  animate: ->
    if (@firstAnim)
      @firstAnim = false
      @squareSeq = @pos1
    else
      @firstAnim = true
      @squareSeq = @pos2

  draw: ->


class Alien1 extends SquaryObject
  draw: ->