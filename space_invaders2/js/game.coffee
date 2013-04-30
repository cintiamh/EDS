# Game constraints
BLOCK_SIZE = 3
WIDTH_BLOCKS = 184
HEIGHT_BLOCKS = 191
WIDTH = WIDTH_BLOCKS * BLOCK_SIZE
HEIGHT = HEIGHT_BLOCKS * BLOCK_SIZE
BORDER = 4 * BLOCK_SIZE

canon = null
aliensArr = []
bulletsArr = []

# canon values
canon_vel = 15
bullet_vel = 5

# aliens values
aliensDirection = 1
alienMovPause = 500
aliensSideMove = 2 * BLOCK_SIZE
aliensDownMove = 6 * BLOCK_SIZE
alienStrArr = ['alien03', 'alien02', 'alien02', 'alien01', 'alien01']
aliensWidthArr = [8 * BLOCK_SIZE, 11 * BLOCK_SIZE, 11 * BLOCK_SIZE, 12 * BLOCK_SIZE, 12 * BLOCK_SIZE]

# Setting up Kinetic Stage:
stage = new Kinetic.Stage
  container: "container"
  width: WIDTH
  height: HEIGHT

# Layers
backgroundLayer = new Kinetic.Layer
aliensLayer = new Kinetic.Layer

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

# Creating the black background
background = new Kinetic.Rect
  x: 0
  y: 0
  width: WIDTH
  height: HEIGHT
  fill: "#000000"

backgroundLayer.add(background)

# Staging the background layer
stage.add(backgroundLayer)

# Loading image that has all aliens and the canon
imageObj = new Image()
imageObj.src = "images/aliens_all.png"

imageObj.onload = ->
  # Creating the Canon
  canon = new Kinetic.Sprite
    x: WIDTH / 2 - 7 * BLOCK_SIZE
    y: HEIGHT - (8 * BLOCK_SIZE + BORDER)
    image: imageObj
    animation: 'canon'
    animations: animations
    frameRate: 1
    width: 15 * BLOCK_SIZE
    height: 8 * BLOCK_SIZE
  aliensLayer.add(canon)
  stage.add(aliensLayer)
  canon.start()

  # Create a new group of aliens
  for num1 in [0..4]
    for num2 in [0..10]
      new_alien = new Kinetic.Sprite
        x: num2 * (12 + 2) * BLOCK_SIZE
        y: num1 * (8 + 6) * BLOCK_SIZE
        image: imageObj
        animation: alienStrArr[num1]
        animations: animations
        frameRate: 2
        width: aliensWidthArr[num1]
        height: 8 * BLOCK_SIZE
      aliensLayer.add(new_alien)
      new_alien.start()
      aliensArr.push(new_alien)
  moveAliens(BORDER, BORDER)


# Control the Canon
document.onkeydown = (event) ->
  switch event.keyCode
    # left arrow / a
    when 37, 65
      moveCanon(-1)
    # right arrow / d
    when 39, 68
      moveCanon(1)
    # space bar
    when 32
      shootBullet()
  event.preventDefault()

# Canon and bullets functions

moveCanon = (direction) ->
  speed = direction * canon_vel
  next_pos = canon.getX() + speed
  # verifies if the canon doesnt get outside the screen before moving it
  if next_pos > BORDER && next_pos < (WIDTH - (15 * BLOCK_SIZE + BORDER))
    canon.move(speed, 0)

shootBullet = ->
  bullet = new Kinetic.Rect
    x: canon.getX() + canon.getWidth() / 2 - 1
    y: canon.getY() - canon.getHeight() / 2
    width: BLOCK_SIZE
    height: 4 * BLOCK_SIZE
    fill: "#FFCCCC"
  aliensLayer.add(bullet)
  bulletsArr.push(bullet)

checkBulletsOut = ->
  for bullet in bulletsArr
    if bullet && bullet.getY() < 0
      removeBullet(bullet)

removeBullet = (bullet) ->
  if bullet
    index = bulletsArr.indexOf(bullet)
    bullet.destroy()
    bulletsArr.splice(index, 1)

bulletsAnimation = new Kinetic.Animation (frame) ->
  checkBulletsOut()
  for bullet in bulletsArr
    if bullet
      bullet.move(0, -bullet_vel)

bulletsAnimation.start()

# Aliens functions

moveAliens = (x, y) ->
  _.each(aliensArr, (alien) ->
    alien.move(x, y)
  )

removeAlien = (alien) ->
  if alien
    index = aliensArr.indexOf(alien)
    alien.destroy()
    aliensArr.splice(index, 1)

checkAliensGoDown = ->
  _.each(aliensArr, (alien) ->
    if aliensDirection < 0 && alien.getX() - aliensSideMove < 0
      return true
    else if aliensDirection > 0 && alien.getX() + aliensSideMove > WIDTH - 12 * BLOCK_SIZE
      return true
  )
  false

animateAliens = ->
  if checkAliensGoDown()
    direction = -1 * aliensDirection
    moveAliens(0, aliensDownMove)
  else
    moveAliens(aliensSideMove * direction, 0)

setInterval(animateAliens, alienMovPause)