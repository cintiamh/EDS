BLOCK_SIZE = 3
WIDTH_NUM_BLOCKS = 184
HEIGHT_NUM_BLOCKS = 191
WIDTH = WIDTH_NUM_BLOCKS * BLOCK_SIZE
HEIGHT = HEIGHT_NUM_BLOCKS * BLOCK_SIZE
BORDER = 4 * BLOCK_SIZE

canon = null
explosion = null

# aliens movement
alienSideMove = 2 * BLOCK_SIZE
alienDownMove = 6 * BLOCK_SIZE
alienWidth = 12 * BLOCK_SIZE
alienMoveDirection = 1
aliensGroupLimits =
  minX: -1
  maxX: -1
  minY: -1
  maxY: -1
startTime = 0
aliensCount = 0
checkingCol = false

# speeds
alienMovPause = 500
canonSpeed = 15
bulletSpeed = 5

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

explosionAnim =
  idle: [
    {
      x: 0
      y: 0
      width: 0
      height: 0
    }
  ]
  explosion: [
    {
      x: 5
      y: 3
      width: 32
      height: 33
    }
    {
      x: 42
      y: 3
      width: 30
      height: 33
    }
    {
      x: 79
      y: 3
      width: 33
      height: 33
    }
    {
      x: 121
      y: 3
      width: 33
      height: 33
    }
  ]

# The group of aliens that moves in a block
aliensGroup = new Kinetic.Group()

# Group for the bullets
bulletsGroup = new Kinetic.Group()

# Group of explosions
explosionsGroup = new Kinetic.Group()

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
    alien.start()

  checkAliensMinMax()

  stage.add(aliensLayer)

# The image object for the Sprites (aliens, canon, etc)
explosionImg = new Image()
explosionImg.src = "img/explosion.png"

explosionImg.onload = ->
  # Renders the canon
  explosion = new Kinetic.Sprite
    x: WIDTH
    y: HEIGHT
    image: explosionImg
    animation: 'idle'
    animations: explosionAnim
    frameRate: 4

  aliensLayer.add(explosion)
  explosion.start()

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
          # calculates the middle of the canon from where the bullet comes out
          shootNewBullet(canon.getPosition().x + canon.getWidth() / 2 - BLOCK_SIZE / 2, canon.getPosition().y)

    # moving bullet animation
    for bullet in bulletsGroup.getChildren() #bulletsArr
      if bullet
        bullet.move(0, -bulletSpeed)

    checkBulletCol()

aliensAnimation = new Kinetic.Animation (frame) ->
  if frame.time - startTime > alienMovPause
    startTime = frame.time
    moveAliensBlock()

canonAnimation.start()
aliensAnimation.start()

# Moves the whole block of aliens, calculates the max and min width and height
moveAliensBlock = ->
  if (alienMoveDirection > 0 && (aliensGroupLimits.maxX + alienWidth + aliensGroup.getX() + BORDER) >= WIDTH) || (alienMoveDirection < 0 && (aliensGroupLimits.minX + aliensGroup.getX()) <= BORDER)
    aliensGroup.move(0, alienDownMove)
    changeAlienDirection()
  else
    aliensGroup.move(alienSideMove * alienMoveDirection, 0)

checkAliensMinMax = ->
  resetAliensGroupLimits()
  for alien in aliensGroup.getChildren()
    if alien && alien.isVisible()
      if aliensGroupLimits.minX < 0 || aliensGroupLimits.minX > alien.getX()
        aliensGroupLimits.minX = alien.getX()
      if aliensGroupLimits.minY < 0 || aliensGroupLimits.minY > alien.getY()
        aliensGroupLimits.minY = alien.getY()
      if aliensGroupLimits.maxX < 0 || aliensGroupLimits.maxX < alien.getX()
        aliensGroupLimits.maxX = alien.getX()
      if aliensGroupLimits.maxY < 0 || aliensGroupLimits.maxY < alien.getY()
        aliensGroupLimits.maxY = alien.getY()

resetAliensGroupLimits = ->
  aliensGroupLimits =
    minX: -1
    maxX: -1
    minY: -1
    maxY: -1

changeAlienDirection = ->
  alienMoveDirection *= -1

moveCanon = (speed) ->
  if speed < 0 && canon.getPosition().x > BORDER * 2
    canon.move(speed, 0)
  if speed > 0 && canon.getPosition().x < WIDTH - BORDER - 15 * BLOCK_SIZE
    canon.move(speed, 0)

shootNewBullet = (x, y) ->
  bulletsGroup.add(new Kinetic.Rect
    x: x
    y: y
    width: BLOCK_SIZE
    height: 4 * BLOCK_SIZE
    fill: "#FFCCCC"
  )
  canonLayer.add(bulletsGroup)

checkBulletCol = ->
    for bullet in bulletsGroup.getChildren()

      if !bullet
        continue
      else
        bulletX = bullet.getPosition().x
        bulletY = bullet.getPosition().y
        # bullet is oustside of the screen
        if bulletY <= 0
          bullet.destroy()
          continue
        else if bulletY <= aliensGroupLimits.maxY
          offsetX = aliensGroup.getPosition().x
          offsetY = aliensGroup.getPosition().y

          for alien in aliensGroup.getChildren()
            if alien
              alienStartX = alien.getPosition().x + offsetX
              alienStartY = alien.getPosition().y + offsetY
              alienEndX = alienStartX + alien.getWidth()
              alienEndY = alienStartY + alien.getHeight()
              # check bullet and alien collision
              if bulletX > alienStartX and bulletX < alienEndX
                if bulletY > alienStartY and bulletY < alienEndY
                  bullet.destroy()
                  alien.destroy()
                  explosion.setPosition(alienStartX, alienStartY)
                  explosion.setAnimation("explosion")
                  explosion.afterFrame(1, -> explosion.setAnimation("idle") )
                  checkAliensMinMax()
                  break
