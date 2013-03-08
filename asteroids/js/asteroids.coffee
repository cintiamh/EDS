WIDTH = window.innerWidth
HEIGHT = window.innerHeight
MAX_SPEED = 5
DRAG = 0.01

ship = null

stage = new Kinetic.Stage
  container: 'container'
  width: WIDTH
  height: HEIGHT

# Creating the stars on the background
starsLayer = new Kinetic.Layer

starsGroup = new Kinetic.Group

createStars = (num) ->
  for n in [0..num]
    starsGroup.add(new Kinetic.Star(
      x: Math.random() * WIDTH
      y: Math.random() * HEIGHT
      numPoints: 5
      innerRadius: Math.random() * 1 + 0.5
      outerRadius: Math.random() * 2 + 1.5
      fill: '#FFFFAA'
    ))

createStars(200)
starsLayer.add(starsGroup)

# Draw the spaceship
shipLayer = new Kinetic.Layer

ship = new Kinetic.Polygon(
  points:[10, 0, 20, 30, 0, 30]
  sides: 3
  radius: 10
  fill: "#42B4E6"
)

ship.setPosition(WIDTH / 2, HEIGHT / 2)

shipLayer.add(ship)

shipAnimation = new Kinetic.Animation((frame) ->
  if ship
    # checks for keyboard inputs to move the ship
    document.onkeydown = (event) ->
      switch event.keyCode
        # rotate to the left
        when 37, 65
          rotateShip(frame, -1)
        # up
        when 38, 87
          console.log 'up'
          ship.move(1,0)
        # rotate to the right
        when 39, 68
          rotateShip(frame, 1)
        # down
        when 40, 83
          console.log 'down'
        # space bar
        when 32
          console.log 'pew'
shipLayer)

shipAnimation.start()

rotateShip = (frame, dir) ->
  angularSpeed = Math.PI / 2
  angleDiff = frame.timeDiff * angularSpeed / 1000
  ship.rotate(dir * angleDiff)

stage.add(starsLayer)
stage.add(shipLayer)





