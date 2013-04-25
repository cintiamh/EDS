window.Game = {
  WIDTH: 800
  HEIGHT: 600
  NUM_STARS: 200

  SHIP_MAX_VEL: 4
  SHIP_DRAG: 0.01
  BULLET_SPEED: 5
}

ship = null
game = null

document.onkeydown = (event) ->
  switch event.keyCode
    # rotate to the left
    when 37, 65
      ship.setRotation(-1)
    # up
    when 38, 87
      ship.setAcceleration(.2)
    # rotate to the right
    when 39, 68
      ship.setRotation(1)
    # down
    when 40, 83
      console.log 'down'
    # space bar
    when 32
      ship.createBullet(game.shipLayer)
    else
      ship.endThrust()

  event.preventDefault()

document.onkeyup = (event) ->
  switch event.keyCode
    when 38, 87
      ship.endThrust()
  # rotate to the left
    when 37, 65
      ship.setRotation(0)
  # rotate to the right
    when 39, 68
      ship.setRotation(0)

window.onload = ->
  imageObj = new Image()
  imageObj.src = 'images/double_ship.png'
  game = new Game.Main(Game.WIDTH, Game.HEIGHT)
  game.createBackground()
  game.createStars(Game.NUM_STARS)
  imageObj.onload = ->
    ship = new Game.Ship(Game.WIDTH/2, Game.HEIGHT/2, imageObj)
    game.shipLayer.add(ship.ship_obj)
    ship.ship_obj.start()
    console.log ship.ship_obj.getOffset()
  game.start()

  anim_loop = new Kinetic.Animation( (frame) ->
    time = frame.time
    timeDiff = frame.timeDiff
    frameRate = frame.frameRate
    if ship
      ship.moveShip()
      ship.rotate(frame)
      ship.fixPosition()
      ship.moveBullets()
      ship.checkBullets()
  game.shipLayer)

  anim_loop.start()
