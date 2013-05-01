# Game constraints
BLOCK_SIZE = 3
WIDTH_BLOCKS = 184
HEIGHT_BLOCKS = 191
WIDTH = WIDTH_BLOCKS * BLOCK_SIZE
HEIGHT = HEIGHT_BLOCKS * BLOCK_SIZE
BORDER = 4 * BLOCK_SIZE

canon = null
explosion = null
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
start_time = 0
game_over = false

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

explosionImg = new Image()
explosionImg.src = "images/explosion.png"

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
      checkBulletCol(bullet)
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
    alienMovPause -= 10

checkAliensGoDown = ->
  go_down = false
  _.each(aliensArr, (alien) ->
    next_pos = alien.getX() + aliensDirection * aliensSideMove
    if next_pos < BORDER || next_pos + 12 * BLOCK_SIZE > WIDTH - BORDER
      go_down = true
  )
  go_down

animateAliens = ->
  if checkAliensGoDown()
    aliensDirection = -1 * aliensDirection
    moveAliens(0, aliensDownMove)
  else
    moveAliens(aliensSideMove * aliensDirection, 0)

#timerId = setInterval(animateAliens, alienMovPause)

checkBulletCol = (bullet) ->
  _.each(aliensArr, (alien) ->
    bullet_x = bullet.getX()
    bullet_y = bullet.getY()
    alien_x_min = alien.getX()
    alien_y_min = alien.getY()
    alien_x_max = alien_x_min + alien.getWidth()
    alien_y_max = alien_y_min + alien.getHeight()
    if bullet_x > alien_x_min && bullet_x < alien_x_max && bullet_y > alien_y_min && bullet_y < alien_y_max
      explosion.setPosition(alien_x_min, alien_y_min)
      explosion.setAnimation("explosion")
      explosion.afterFrame(1, -> explosion.setAnimation("idle"))
      removeAlien(alien)
      removeBullet(bullet)
  )

aliensAnimation = new Kinetic.Animation (frame) ->
  #console.log frame.time
  if game_over
    aliensAnimation.stop()
  if start_time == 0 || frame.time - start_time > alienMovPause
    animateAliens()
    start_time = frame.time

aliensAnimation.start()

checkGameOver = ->
  _.each(aliensArr, (alien) ->
    canon_x = canon.getX()
    canon_y = canon.getY()
    alien_x_min = alien.getX()
    alien_y_min = alien.getY()
    alien_x_max = alien_x_min + alien.getWidth()
    alien_y_max = alien_y_min + alien.getHeight()
    if canon_x + canon.getWidth() > alien_x_min && canon_x < alien_x_max && canon_y + canon.getHeight() > alien_y_min && canon_y < alien_y_max
      game_over = true
    else if alien_y_max > HEIGHT
      game_over = true
  )