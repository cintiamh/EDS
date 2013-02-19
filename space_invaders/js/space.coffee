BLOCK_SIZE = 3
WIDTH_BLOCKS = 190
HEIGHT_BLOCKS = 197
WIDTH = WIDTH_BLOCKS * BLOCK_SIZE
HEIGHT = HEIGHT_BLOCKS * BLOCK_SIZE

aliensArr = []
startTime = 0
movCount = 0
movDirection = 1
movSideDist = 2 * BLOCK_SIZE
movDownDist = 6 * BLOCK_SIZE

stage = new Kinetic.Stage({
  container: "container"
  width: WIDTH
  height: HEIGHT
})

layer = new Kinetic.Layer()

# Create a black background first (to stay behind everything else)
background = new Kinetic.Rect
  x: 0
  y: 0
  width: WIDTH
  height: HEIGHT
  fill: "#000000"

layer.add(background)

# Animations images mapping array for Sprites
animations =
  alien01: [
    {
      x: BLOCK_SIZE
      y: BLOCK_SIZE
      width: 12 * BLOCK_SIZE
      height: 8 * BLOCK_SIZE
    }
    {
      x: 14 * BLOCK_SIZE
      y: BLOCK_SIZE
      width: 12 * BLOCK_SIZE
      height: 8 * BLOCK_SIZE
    }
  ]
  alien02: [
    {
      x: BLOCK_SIZE
      y: 10 * BLOCK_SIZE
      width: 11 * BLOCK_SIZE
      height: 8 * BLOCK_SIZE
    }
    {
      x: 13 * BLOCK_SIZE
      y: 10 * BLOCK_SIZE
      width: 11 * BLOCK_SIZE
      height: 8 * BLOCK_SIZE
    }
  ]
  alien03: [
    {
      x: BLOCK_SIZE
      y: 19 * BLOCK_SIZE
      width: 8 * BLOCK_SIZE
      height: 8 * BLOCK_SIZE
    }
    {
      x: 10 * BLOCK_SIZE
      y: 19 * BLOCK_SIZE
      width: 8 * BLOCK_SIZE
      height: 8 * BLOCK_SIZE
    }
  ]
  spaceship: [
    {
    x: BLOCK_SIZE
    y: (3 * 8 + 4) * BLOCK_SIZE
    width: 16 * BLOCK_SIZE
    height: 8 * BLOCK_SIZE
    }
  ]
  canon: [
    {
      x: BLOCK_SIZE
      y: (4 * 8 + 5) * BLOCK_SIZE
      width: 15 * BLOCK_SIZE
      height: 8 * BLOCK_SIZE
    }
  ]
  hidden: [
    {
      x: 0
      y: 0
      width: 0
      height: 0
    }
  ]

# image object that loads the image file
imageObj = new Image()

# The aliens are organized inside a group (To move together)
aliensGroup = new Kinetic.Group()

imageObj.onload = ->
  for num1 in [0..4]
    for num2 in [0..10]
      if num1 == 0
        aliensArr.push(new Alien(
          BLOCK_SIZE + num2 * (12 + 2) * BLOCK_SIZE
          num1 * (8 + 6) * BLOCK_SIZE
          imageObj
          'alien03'
          animations
          1
        ))
      if num1 == 1 || num1 == 2
        aliensArr.push(new Alien(
          num2 * (12 + 2) * BLOCK_SIZE
          num1 * (8 + 6) * BLOCK_SIZE
          imageObj
          'alien02'
          animations
          1
        ))
      if num1 == 3 || num1 == 4
        aliensArr.push(new Alien(
          num2 * (12 + 2) * BLOCK_SIZE
          num1 * (8 + 6) * BLOCK_SIZE
          imageObj
          'alien01'
          animations
          1
        ))

  for alien in aliensArr
    aliensGroup.add(alien.kinetic_sprite)
    layer.add(aliensGroup)
    alien.kinetic_sprite.attrs.frameRate = 2
    alien.kinetic_sprite.start()


  aliensGroup.move(BLOCK_SIZE, BLOCK_SIZE)

stage.add(layer)

animation = new Kinetic.Animation((frame) ->
  if frame.time - startTime > 500
    startTime = frame.time
    if movCount % 16 == 15
      aliensGroup.move(0, movDownDist)
      movDirection *= -1
    else
      aliensGroup.move(movDirection * movSideDist, 0)
    movCount++
)

animation.start()

imageObj.src = "img/aliens_all.png"

class AlienBlock
  constructor: ->
    @aliensGroup = new Kinetic.Group()

  initialize: ->
    for alien in aliensArr
      @aliensGroup.add(alien.kinetic_sprite)
      layer.add(aliensGroup)
      #alien.kinetic_sprite.attrs.frameRate = 2
      alien.kinetic_sprite.start()

class SpriteImage
  constructor: (@x, @y, @image, @animation, @animations, @framerate) ->
    @alive = true
    @kinetic_sprite = new Kinetic.Sprite
      x: @x
      y: @y
      image: @image
      animation: @animation
      animations: @animations
      frameRate: @framerate

  kill: ->
    @alive = false
    @kinetic_sprite.setAnimation('hidden')

  isAlive: ->
    return @alive

class Alien extends SpriteImage
  setFrameRate: (@framerate) ->
    @kinetic_sprite.attrs.frameRate = @framerate
    @kinetic_sprite.start()
