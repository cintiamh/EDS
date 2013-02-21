BLOCK_SIZE = 3
WIDTH_BLOCKS = 184
HEIGHT_BLOCKS = 191
WIDTH = WIDTH_BLOCKS * BLOCK_SIZE
HEIGHT = HEIGHT_BLOCKS * BLOCK_SIZE

aliensArr = []
bulletsArr = []
canon = null
startTime = 0
movCount = 0
movDirection = 1
movSideDist = 2 * BLOCK_SIZE
movDownDist = 6 * BLOCK_SIZE
canonSpeed = 15
bulletSpeed = 20

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
  # animate the bullet
  if bulletsArr.length > 0
    for bul in bulletsArr
      if (bul.alive)
        bul.move()
        bul.checkAlienCol()
    #checkBulletCollision()
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

class SpriteImage
  constructor: (@x, @y, @image, @animation, @animations, @frameRate) ->
    @alive = true
    @width = 0
    @height = 0
    @kinetic_sprite = new Kinetic.Sprite
      x: @x
      y: @y
      image: @image
      animation: @animation
      animations: @animations
      frameRate: @frameRate
    @position = @kinetic_sprite.getPosition()

  kill: ->
    @alive = false
    @kinetic_sprite.setAnimation('hidden')

  updatePosition: ->
    @position = @kinetic_sprite.getPosition()

# class to represent each one of the individual alien and its functionalities
class Alien extends SpriteImage
  constructor: (@x, @y, @animation) ->
    super(@x, @y, imageObj, @animation, animations, 2)
    @alive = true
    @height = 8 * BLOCK_SIZE
    switch @animation
      when 'alien01'
        @width = 8 * BLOCK_SIZE
      when 'alien02'
        @width = 11 * BLOCK_SIZE
      when 'alien03'
        @width = 12 * BLOCK_SIZE

  setFrameRate: (@framerate) ->
    @kinetic_sprite.attrs.frameRate = @framerate
    @kinetic_sprite.start()

# class to represent the shooter that stays at the base of the screen (player)
class Canon extends SpriteImage
  constructor: ->
    @speed = 0
    super(
      WIDTH / 2 - 7 * BLOCK_SIZE
      HEIGHT - 8 * BLOCK_SIZE
      imageObj
      'canon'
      animations
      1
    )
    @width = 15 * BLOCK_SIZE
    @height = 8 * BLOCK_SIZE
    @kinetic_sprite.setWidth(15 * BLOCK_SIZE)
    @kinetic_sprite.setHeight(8 * BLOCK_SIZE)

  startMove: (vel) ->
    @speed = vel

  stopMove: ->
    @speed = 0

  shoot: ->
    console.log("pew!")
    bulletsArr.push(new Bullet(
      @kinetic_sprite.getX()
      @kinetic_sprite.getY()
      bulletSpeed * -1
    ))

  move: ->
    vel = @speed
    sprite = @kinetic_sprite
    x = sprite.getX()
    # limits the move inside the screeen
    if ((vel < 0 and x > 0) or (vel > 0 and x < WIDTH - 15 * BLOCK_SIZE))
      sprite.move(vel, 0)

class Bullet
  constructor: (@x, @y, @speed) ->
    @alive = true
    @bullet = new Kinetic.Rect
      x: @x + canon.kinetic_sprite.getWidth() / 2
      y: @y
      width: BLOCK_SIZE
      height: 4 * BLOCK_SIZE
      fill: '#FFCCCC'
    layer.add(@bullet)
    @position = @bullet.getPosition()

  move: ->
    vel = @speed
    y = @bullet.getY()
    if (y < 0 or y > HEIGHT)
      @kill()
    else
      @bullet.setY(y + @speed)

  kill: ->
    @alive = false
    @bullet.setHeight(0)

  updatePosition: ->
    @position = @bullet.getPosition()

  checkAlienCol: ->
    if (@alive)
      @updatePosition()
      for alien in aliensArr
        if alien.alive
          alien.updatePosition()
          if (@position.x > alien.position.x and @position.x < alien.position.x + alien.width)
            if (@position.y > alien.position.y and @position.y < alien.position.y + alien.height)
              alien.kill()
              @kill()







