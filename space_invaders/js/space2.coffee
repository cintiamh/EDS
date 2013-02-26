BLOCK_SIZE = 3
WIDTH_NUM_BLOCKS = 184
HEIGHT_NUM_BLOCKS = 191
WIDTH = WIDTH_NUM_BLOCKS * BLOCK_SIZE
HEIGHT = HEIGHT_NUM_BLOCKS * BLOCK_SIZE
BORDER = 4 * BLOCK_SIZE

canon = null

# aliens movement
alienSideMove = 2 * BLOCK_SIZE
alienDownMove = 6 * BLOCK_SIZE
alienWidth = 12 * BLOCK_SIZE
alienMoveDirection = 1
aliensGroupStartPos = { x: -1, y: -1 }
aliensGroupEndPos = { x: -1, y: -1 }
aliensGroupExt = { x: -1, y: -1 }
startTime = 0
aliensCount = 0

# speeds
alienMovPause = 1
canonSpeed = 15
bulletSpeed = 15

alienStrArr = ['alien03', 'alien02', 'alien02', 'alien01', 'alien01']
aliensWidthArr = [8 * BLOCK_SIZE, 11 * BLOCK_SIZE, 11 * BLOCK_SIZE, 12 * BLOCK_SIZE, 12 * BLOCK_SIZE]
bulletsArr = []

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
imageObj.src = "img/aliens_all.png"

imageObj.onload = ->

  # Renders the canon
  canon = new Kinetic.Sprite
    x: WIDTH / 2 - 7 * BLOCK_SIZE
    y: HEIGHT - (8 * BLOCK_SIZE + BORDER)
    image: imageObj
    animation: 'canon'
    animations: animations
    frameRate: 1
    width: 15 * BLOCK_SIZE
    height: 8 * BLOCK_SIZE

  canonLayer.add(canon)
  stage.add(canonLayer)
  canon.start()

  # Create a new group of aliens
  for num1 in [0..4]
    for num2 in [0..10]
      aliensGroup.add(new Kinetic.Sprite
        x: num2 * (12 + 2) * BLOCK_SIZE
        y: num1 * (8 + 6) * BLOCK_SIZE
        image: imageObj
        animation: alienStrArr[num1]
        animations: animations
        frameRate: 2
        width: aliensWidthArr[num1]
        height: 8 * BLOCK_SIZE
      )

  aliensLayer.add(aliensGroup)
  aliensGroup.setPosition(BORDER, BORDER)

  # start aliens sprite animation
  for alien in aliensGroup.getChildren()

    console.log(alien.getHeight())
    alien.start()

  stage.add(aliensLayer)

canonAnimation = new Kinetic.Animation (frame) ->
  if canon
    # checks for keyboard inputs to move the canon
    document.onkeydown = (event) ->
      switch event.keyCode
        # left arrow / a
        when 37, 65
          moveCanon(-canonSpeed)
        # right arrow / d
        when 39, 68
          moveCanon(canonSpeed)
        # space bar
        when 32
          #canon.shoot()
          shootNewBullet(canon.getPosition().x + canon.getWidth() / 2 - BLOCK_SIZE / 2, canon.getPosition().y)


    for bullet in bulletsArr
      bullet.move(0, -bulletSpeed)
      #bullet.checkAlienCol()

    checkBulletCol()

aliensAnimation = new Kinetic.Animation (frame) ->
  if frame.time - startTime > 500
    startTime = frame.time
    moveAliensBlock()

canonAnimation.start()
aliensAnimation.start()

moveAliensBlock = ->
  for alien in aliensGroup.getChildren()
    if aliensGroupStartPos.x < 0 || aliensGroupStartPos.x > alien.getPosition().x
      aliensGroupStartPos.x = alien.getPosition().x
    if aliensGroupStartPos.y < 0 || aliensGroupStartPos.y > alien.getPosition().y
      aliensGroupStartPos.y = alien.getPosition().y
    if aliensGroupEndPos.x < 0 || aliensGroupEndPos.x < alien.getPosition().x
      aliensGroupEndPos.x = alien.getPosition().x
    if aliensGroupEndPos.y < 0 || aliensGroupEndPos.y < alien.getPosition().y
      aliensGroupEndPos.y = alien.getPosition().y

  if (alienMoveDirection > 0 && (aliensGroupEndPos.x + alienWidth + aliensGroup.getPosition().x + BORDER) >= WIDTH) || (alienMoveDirection < 0 && (aliensGroupStartPos.x + aliensGroup.getPosition().x) <= BORDER)
    aliensGroup.move(0, alienDownMove)
    changeAlienDirection()
  else
    aliensGroup.move(alienSideMove * alienMoveDirection, 0)

changeAlienDirection = ->
  alienMoveDirection *= -1

moveCanon = (speed) ->
  if speed < 0 && canon.getPosition().x > BORDER * 2
    canon.move(speed, 0)
  if speed > 0 && canon.getPosition().x < WIDTH - BORDER - 15 * BLOCK_SIZE
    canon.move(speed, 0)

shootNewBullet = (x, y) ->
  bullet = new Kinetic.Rect
    x: x
    y: y
    width: BLOCK_SIZE
    height: 4 * BLOCK_SIZE
    fill: "#FFCCCC"
  bulletsArr.push(bullet)
  canonLayer.add(bullet)

checkBulletCol = ->
  index = 0
  for bullet in bulletsArr
    # bullet is outside of the screen
    if bullet && bullet.getPosition().y < 0
      bulletsArr.splice(index, 1)
      bullet.remove()

    # check if bullet hit an alien

    else
      index++
