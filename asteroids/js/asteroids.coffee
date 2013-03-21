# Constants
WIDTH = window.innerWidth
HEIGHT = window.innerHeight
MAX_SPEED = 4
DRAG = 0.01

ship = null

stage = new Kinetic.Stage
  container: 'container'
  width: WIDTH
  height: HEIGHT

backgroundLayer = new Kinetic.Layer

backgroundLayer.add(new Kinetic.Rect(
  x: 0
  y: 0
  width: WIDTH
  height: HEIGHT
  fill: "#000000"
))

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
  points:[-15, -10, 15, 0, -15, 10]
  sides: 3
  radius: 10
  fill: "#42B4E6"
)

ship.setPosition(WIDTH / 2, HEIGHT / 2)
ship.setRotation(-Math.PI/2)

ship_velocity = {
  x: 0
  y: 0
}
ship_acceleration = 0

shipLayer.add(ship)

shipAnimation = new Kinetic.Animation((frame) ->
  if ship
    # checks for keyboard inputs to move the ship
    document.onkeydown = (event) ->
      switch event.keyCode
        # rotate to the left
        when 37, 65
          rotateShip(frame, -2)
        # up
        when 38, 87
          console.log 'up'
          #ship.move(0,-1)
          setShipAcceleration(1)
        # rotate to the right
        when 39, 68
          rotateShip(frame, 2)
        # down
        when 40, 83
          console.log 'down'
        # space bar
        when 32
          console.log 'pew'
    moveShip()
shipLayer)

moveShip = ->
  if (ship_acceleration != 0)
    movementAngle = ship.getRotation()
    ship_velocity.x += Math.cos(movementAngle) * ship_acceleration
    ship_velocity.y += Math.sin(movementAngle) * ship_acceleration
    ship_acceleration = 0
  speed = hypotenuse(ship_velocity.x, ship_velocity.y)
  if speed > MAX_SPEED
    speed = MAX_SPEED
  else if speed > 0.1
    speed -= DRAG

  speedAngle = Math.atan2(ship_velocity.y, ship_velocity.x)
  ship_velocity.x = Math.cos(speedAngle) * speed
  ship_velocity.y = Math.sin(speedAngle) * speed

  #ship.setX(ship.getX() + ship_velocity.x)
  #ship.setY(ship.getY() + ship_velocity.y)
  ship.move(ship_velocity.x, ship_velocity.y)

  # adjust screen
  adjustScreenPosition(ship, WIDTH, HEIGHT);

setShipAcceleration = (accel) ->
  ship_acceleration += accel
  #console.log ship_acceleration

hypotenuse = (x, y) ->
  Math.sqrt(x * x + y * y)

adjustScreenPosition = (shape, width, height) ->
  if shape.getX() >= width
    shape.setX(0)
  else if shape.getX() < 0
    shape.setX(width)
  if shape.getY() >= height
    shape.setY(0)
  else if shape.getY() < 0
    shape.setY(height)

shipAnimation.start()

rotateShip = (frame, dir) ->
  angularSpeed = Math.PI / 2
  angleDiff = frame.timeDiff * angularSpeed / 1000
  ship.rotate(dir * angleDiff)

stage.add(backgroundLayer)
stage.add(starsLayer)
stage.add(shipLayer)





