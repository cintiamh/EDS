BLOCK_SIZE = 3
WIDTH_BLOCKS = 184
HEIGHT_BLOCKS = 191
WIDTH = WIDTH_BLOCKS * BLOCK_SIZE
HEIGHT = HEIGHT_BLOCKS * BLOCK_SIZE

aliensArr = []
canon = null
startTime = 0
movCount = 0
movDirection = 1
movSideDist = 2 * BLOCK_SIZE
movDownDist = 6 * BLOCK_SIZE
canonSpeed = 15

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
  canon = new Canon()
  layer.add(canon.kinetic_sprite)

  for num1 in [0..4]
    for num2 in [0..10]
      if num1 == 0
        aliensArr.push(new Alien(
          BLOCK_SIZE + num2 * (12 + 2) * BLOCK_SIZE
          num1 * (8 + 6) * BLOCK_SIZE
          'alien03'
        ))
      if num1 == 1 || num1 == 2
        aliensArr.push(new Alien(
          num2 * (12 + 2) * BLOCK_SIZE
          num1 * (8 + 6) * BLOCK_SIZE
          'alien02'
        ))
      if num1 == 3 || num1 == 4
        aliensArr.push(new Alien(
          num2 * (12 + 2) * BLOCK_SIZE
          num1 * (8 + 6) * BLOCK_SIZE
          'alien01'
        ))

  for alien in aliensArr
    aliensGroup.add(alien.kinetic_sprite)
    layer.add(aliensGroup)
    alien.kinetic_sprite.attrs.frameRate = 2
    alien.kinetic_sprite.start()


  aliensGroup.move(BLOCK_SIZE, BLOCK_SIZE)

  document.onkeydown = (event) ->
    switch event.keyCode
      # left arrow / a
      when 37, 65
        canon.startMove(-canonSpeed)
      # right arrow / d
      when 39, 68
        canon.startMove(canonSpeed)
      # space bar
      when 32
        canon.shoot()
  document.onkeyup = (event) ->
    canon.stopMove()

stage.add(layer)

animation = new Kinetic.Animation((frame) ->
  # move shooter
  if canon
    canon.move()
  # move aliens
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

class AliensGroup
  constructor: ->
    @aliensGroup = new Kinetic.Group()
    @aliensArr = []

  initialize: ->
    for alien in aliensArr
      @aliensGroup.add(alien.kinetic_sprite)
      layer.add(aliensGroup)
      #alien.kinetic_sprite.attrs.frameRate = 2
      alien.kinetic_sprite.start()

###
# TODO: redo basic sprite class to be extended (constructor, move, detect shoot, etc)
###

class SpriteImage
  constructor: (@x, @y, @image, @animation, @animations, @frameRate) ->
    @alive = true
    @kinetic_sprite = new Kinetic.Sprite
      x: @x
      y: @y
      image: @image
      animation: @animation
      animations: @animations
      frameRate: @frameRate

  setWidth: (width) ->
    @kinetic_sprite.setWidth(width)

  setHeight: (height) ->
    @kinetic_sprite.setHeight(height)

  getWidth: ->
    return @kinetic_sprite.getWidth()

  getHeight: ->
    return @kinetic_sprite.getHeight()

  kill: ->
    @alive = false
    @kinetic_sprite.setAnimation('hidden')

  isAlive: ->
    return @alive

# class to represent each one of the individual alien and its functionalities
class Alien
  constructor: (@x, @y, @animation) ->
    @alive = true
    @kinetic_sprite = new Kinetic.Sprite
      x: @x
      y: @y
      image: imageObj
      animation: @animation
      animations: animations
      frameRate: 2
    @kinetic_sprite.setHeight(8 * BLOCK_SIZE)
    switch @animation
      when 'alien01'
        @kinetic_sprite.setWidth(8 * BLOCK_SIZE)
      when 'alien02'
        @kinetic_sprite.setWidth(11 * BLOCK_SIZE)
      when 'alien03'
        @kinetic_sprite.setWidth(12 * BLOCK_SIZE)

  kill: ->
    @alive = false
    @kinetic_sprite.setAnimation('hidden')

  isAlive: ->
    return @alive

  setFrameRate: (@framerate) ->
    @kinetic_sprite.attrs.frameRate = @framerate
    @kinetic_sprite.start()

# class to represent the shooter that stays at the base of the screen (player)
class Canon
  constructor: ->
    @speed = 0
    @kinetic_sprite = new Kinetic.Sprite
      x: WIDTH / 2 - 7 * BLOCK_SIZE
      y: HEIGHT - 8 * BLOCK_SIZE
      image: imageObj
      animation: 'canon'
      animations: animations
      frameRate: 1
    @kinetic_sprite.setWidth(15 * BLOCK_SIZE)
    @kinetic_sprite.setHeight(8 * BLOCK_SIZE)

  startMove: (vel) ->
    @speed = vel

  stopMove: ->
    @speed = 0

  shoot: ->
    console.log("pew!")

  move: ->
    vel = @speed
    sprite = @kinetic_sprite
    x = sprite.getX()
    # limits the move inside the screeen
    if ((vel < 0 and x > 0) or (vel > 0 and x < WIDTH - 15 * BLOCK_SIZE))
      sprite.move(vel, 0)




