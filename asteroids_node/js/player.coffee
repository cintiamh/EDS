WIDTH = 800
HEIGHT = 600
NUM_STARS = 200

game = new Game.Main(WIDTH, HEIGHT)
game.createBackground()
game.createStars(NUM_STARS)
ship = game.addShip(WIDTH / 2, HEIGHT / 2)

window.$(document).ready ->
  window.$(document).keydown (e) ->
    switch e.keyCode
      when 37, 65
        # left arrow - a
        ship.setRotation(-10)
      when 38, 87
        # up arrow - w
        ship.setAcceleration(.5)
      when 39, 68
        # right arrow - d
        ship.setRotation(10)

    e.preventDefault()

  game.start()

  shipAnim = new Kinetic.Animation((frame) ->
    if game.ship1
      game.ship1.rotate(frame, game.ship1.rotation)
      game.ship1.moveShip()
      console.log game.ship1.ship.getPosition()
    game.shipLayer)

  shipAnim.start()
  #ship.createAnimation()
  #ship.startAnimation()