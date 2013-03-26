WIDTH = 800
HEIGHT = 600
NUM_STARS = 200

game = new Game.Main(WIDTH, HEIGHT)
game.createBackground()
game.createStars(NUM_STARS)
game.addShip(WIDTH / 2, HEIGHT / 2)

$(document).ready ->
  $(document).keydown (e) ->


game.start()