# Constants
SCREEN_WIDTH = window.innerWidth
SCREEN_HEIGHT = window.innerHeight
MAX_SPEED = 5
DRAG = 0.01

asteroids = new Asteroids()
asteroids.start()

# Main game class
class Asteroids
  constructor: ->
    @stage = new Kinetic.Stage(
      container: 'container'
      width: SCREEN_WIDTH
      height: SCREEN_HEIGHT
    )

    @backgroundLayer = new Kinetic.Layer()
    @backgroundLayer.add(new Kinetic.Rect({
      width: SCREEN_WIDTH
      height: SCREEN_HEIGHT
      fill: '#000000'
    }))

    @shipLayer = new Kinetic.Layer()
    ship = new Ship()
    @shipLayer.add(ship.shape)

    @stage.add(@backgroundLayer)
    @stage.add(@shipLayer)

  start: ->
    @stage.start()

class Ship
  constructor: ->
    @shape = new Kinetic.Polygon(
      points: [10, 0, 20, 30, 0, 30]
      sides: 3
      radius: 10
      fill: "#42B4E6"
    )
    @position =
      x: @shape.getX()
      y: @shape.getY()
    @velocity =
      x: 0
      y: 0
    @acceleration = 0
    @rotation = 0
    @bullets = []

