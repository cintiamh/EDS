BLOCK_SIZE = 3
WIDTH_NUM_BLOCKS = 184
HEIGHT_NUM_BLOCKS = 191
WIDTH = WIDTH_NUM_BLOCKS * BLOCK_SIZE
HEIGHT = HEIGHT_NUM_BLOCKS * BLOCK_SIZE

canon = null

# aliens movement
alienSideMove = 2 * BLOCK_SIZE
alienDownMove = 6 * BLOCK_SIZE

# speeds
alienMovPause = 1
canonSpeed = 15
bulletSpeed = 20

alienStrArr = ['alien01', 'alien02', 'alien02', 'alien03', 'alien03']

stage = new Kinetic.Stage
  container: "container"
  width: WIDTH
  height: HEIGHT

backgroundLayer = new Kinetic.Layer

# Create a black background
background = new Kinetic.Rect
  x: 0
  y: 0
  width: WIDTH
  height: HEIGHT
  fill: "#000000"

backgroundLayer.add(background)

# Staging the background layer
stage.add(backgroundLayer)

# create a layer for the aliens
aliensLayer = new Kinetic.Layer

# create a layer for the canon and bullets
canonLayer = new Kinetic.Layer

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

# The group of aliens that moves in a block
aliensGroup = new Kinetic.Group()

# Group for the bullets
bulletsGroup = new Kinetic.Group()

# The image object for the Sprites (aliens, canon, etc)
imageObj = new Image()

imageObj.onload = ->

  # Renders the canon
  canon = new Kinetic.Sprite
    x: WIDTH / 2 - 7 * BLOCK_SIZE
    y: HEIGHT - 8 * BLOCK_SIZE
    image: imageObj
    animation: 'canon'
    animations: animations
    frameRate: 1

  canonLayer.add(canon)
  stage.add(canonLayer)
  canon.start()

  # Create a new group of aliens
  for num1 in [0..4]
    for num2 in [0..10]
      aliensGroup.add(new Kinetic.Sprite
        x: BLOCK_SIZE + num2 * (12 + 2) * BLOCK_SIZE
        y: num1 * (8 + 6) * BLOCK_SIZE
        image: imageObj
        animation: alienStrArr[num1]
        animations: animations
        frameRate: 2
      )

  for alien in aliensGroup.getChildren()
    alien.start()

  aliensLayer.add(aliensGroup)
  stage.add(aliensLayer)

imageObj.src = "img/aliens_all.png"

canonAnimation = new Kinetic.Animation (frame) ->
  if canon
    # checks for keyboard inputs to move the canon
    document.onkeydown = (event) ->
      switch event.keyCode
        # left arrow / a
        when 37, 65
          canon.move(-canonSpeed, 0)
        # right arrow / d
        when 39, 68
          canon.move(canonSpeed, 0)
        # space bar
        when 32
          #canon.shoot()
          console.log("pew")

canonAnimation.start()
