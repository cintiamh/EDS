WIDTH = window.innerWidth #800
HEIGHT = window.innerHeight #600
NUM_STARS = 200
SHIP_MAX_VEL = 4
SHIP_DRAG = 0.01
BULLET_SPEED = 5
ROCK_SPEED = 1
ROCK_RADIUS = 40

ship = null
explosion = null
stars_arr = []
bullets_arr = []
rocks_arr = []
rocks_dir = []

# Ship variables
ship_acceleration = 0
ship_rotation = 0
ship_velocity = { x: 0, y: 0 }

rocks_interval = 2000
rocks_start = 0
points = 0

# Flags
createRocks = false
createExplosion = false
game_over = false

# Animations
ship_animations =
  idle: [
    x: 3
    y: 12
    width: 80
    height: 65
  ]
  thrust: [
    x: 95
    y: 12
    width: 80
    height: 65
  ]

rock_animations =
  idle: [
    x: 0
    y: 0
    width: 90
    height: 90
  ]

explosion_animations =
  idle: [ {x: 0, y: 0, width: 0,height: 0}]
  explosion: [
        { x: 0, y: 0, width: 128, height: 128 }
        { x: 128, y: 0, width: 128, height: 128 }
        { x: 256, y: 0, width: 128, height: 128 }
        { x: 384, y: 0, width: 128, height: 128 }
        { x: 512, y: 0, width: 128, height: 128 }
        { x: 640, y: 0, width: 128, height: 128 }
        { x: 768, y: 0, width: 128, height: 128 }
        { x: 896, y: 0, width: 128, height: 128 }
        { x: 1024, y: 0, width: 128, height: 128 }
        { x: 1152, y: 0, width: 128, height: 128 }
        { x: 1280, y: 0, width: 128, height: 128 }
        { x: 1408, y: 0, width: 128, height: 128 }
        { x: 1536, y: 0, width: 128, height: 128 }
        { x: 1664, y: 0, width: 128, height: 128 }
        { x: 1792, y: 0, width: 128, height: 128 }
        { x: 1920, y: 0, width: 128, height: 128 }
        { x: 2048, y: 0, width: 128, height: 128 }
        { x: 2176, y: 0, width: 128, height: 128 }
        { x: 2304, y: 0, width: 128, height: 128 }
        { x: 2432, y: 0, width: 128, height: 128 }
        { x: 2560, y: 0, width: 128, height: 128 }
        { x: 2688, y: 0, width: 128, height: 128 }
        { x: 2816, y: 0, width: 128, height: 128 }
        { x: 2944, y: 0, width: 128, height: 128 }
      ]

# Initiating Kinetic JS
stage = new Kinetic.Stage
  container: "container"
  width: WIDTH
  height: HEIGHT

# Layers
backgroundLayer = new Kinetic.Layer
gameLayer = new Kinetic.Layer

# Draw Black backgound
backgroundLayer.add new Kinetic.Rect
  x: 0
  y: 0
  width: WIDTH
  height: HEIGHT
  fill: "#000000"

# Draw stars in the background
starsGroup = new Kinetic.Group
for n in [0..NUM_STARS]
  starsGroup.add new Kinetic.Star
    x: Math.random() * WIDTH
    y: Math.random() * HEIGHT
    numPoints: 5
    innerRadius: Math.random() + 0.5
    outerRadius: Math.random() * 2 + 1.5
    fill: "#FFFFAA"
backgroundLayer.add(starsGroup)

# Draw Ship
shipImageObj = new Image()
shipImageObj.src = "images/double_ship.png"
shipImageObj.onload = ->
  ship = new Kinetic.Sprite
    x: WIDTH / 2 - 40
    y: HEIGHT / 2 - 32
    image: shipImageObj
    animation: "idle"
    animations: ship_animations
    frameRate: 1
    width: 80
    height: 65
  ship.setOffset(40, 32)
  gameLayer.add(ship)
  ship.start()

# Draw Rock
rockImageObj = new Image()
rockImageObj.src = "images/asteroid_blue.png"
rockImageObj.onload = ->
  createRocks = true
  createRock(100, 100)

explosionImageObj = new Image()
explosionImageObj.src = "images/explosion_alpha.png"
explosionImageObj.onload = ->
  console.log explosionImageObj
  createExplosion = true
  explosion = new Kinetic.Sprite
    x: 0
    y: 0
    imageObj: explosionImageObj
    animation: 'idle'
    animations: explosion_animations
    frameRate: 5
    width: 128
    height: 128
  explosion.setOffset(64, 64)
  gameLayer.add(explosion)
  explosion.start()

createRock = (x, y) ->
  if createRocks
    rock = new Kinetic.Sprite
      x: x
      y: y
      image: rockImageObj
      animation: "idle"
      animations: rock_animations
      frameRate: 1
      width: 90
      height: 90
    rock.setOffset(45, 45)
    gameLayer.add(rock)
    rock.start()
    rocks_arr.push(rock)
    angle = Math.random() * Math.PI * 2
    velocity = Math.random() * 1 + ROCK_SPEED
    speed = {x: Math.cos(angle) * velocity, y: Math.sin(angle) * velocity }
    rocks_dir.push(speed)

animate_rocks = (frame) ->
  _.each(rocks_arr, (rock) ->
    angular_speed = Math.PI / 2
    angle_diff = frame.timeDiff * angular_speed / 2000
    rock.rotate(angle_diff)
    index = rocks_arr.indexOf(rock)
    rock.move(rocks_dir[index].x, rocks_dir[index].y)
  )

# Ship Functions
set_thrust = ->
  ship.setAnimation('thrust')

end_thrust = ->
  ship.setAnimation('idle')

set_acceleration = (val) ->
  ship_acceleration += val
  set_thrust()

set_rotation = (val) ->
  ship_rotation = val

get_hypotenuse = (x, y) ->
  Math.sqrt(x * x + y * y)

rotate_ship = (frame) ->
  angular_speed = Math.PI / 2
  angle_diff = frame.timeDiff * angular_speed / 1000
  ship.rotate(ship_rotation * angle_diff)

move_ship = ->
  if ship_acceleration != 0
    movement_angle = ship.getRotation()
    ship_velocity.x += Math.cos(movement_angle) * ship_acceleration
    ship_velocity.y += Math.sin(movement_angle) * ship_acceleration
    ship_acceleration = 0

  speed = get_hypotenuse(ship_velocity.x, ship_velocity.y)

  if speed > SHIP_MAX_VEL
    speed = SHIP_MAX_VEL
  else if speed > 0
    speed -= SHIP_DRAG

  speed_angle = Math.atan2(ship_velocity.y, ship_velocity.x)
  ship_velocity.x = Math.cos(speed_angle) * speed
  ship_velocity.y = Math.sin(speed_angle) * speed

  ship.move(ship_velocity.x, ship_velocity.y)

fix_position = ->
  if ship.getX() <= 0
    ship.setX(WIDTH)
  else if ship.getX() >= WIDTH
    ship.setX(0)
  if ship.getY() <= 0
    ship.setY(HEIGHT)
  else if ship.getY() >= HEIGHT
    ship.setY(0)

fix_rocks_position = ->
  _.each(rocks_arr, (rock) ->
    if rock.getX() <= 0
      rock.setX(WIDTH)
    else if rock.getX() >= WIDTH
      rock.setX(0)
    if rock.getY() <= 0
      rock.setY(HEIGHT)
    else if rock.getY() >= HEIGHT
      rock.setY(0)
  )

# Bullets functions
ship_shoot = ->
  bullet = new Kinetic.Rect
    x: ship.getX()
    y: ship.getY()
    width: 8
    height: 4
    fill: '#00FFFF'
  bullet.setRotation(ship.getRotation())
  bullet.move(Math.cos(ship.getRotation()) * 40, Math.sin(ship.getRotation()) * 40)
  gameLayer.add(bullet)
  bullets_arr.push(bullet)

move_bullets = ->
  _.each(bullets_arr, (bullet) ->
    bullet.move(Math.cos(bullet.getRotation()) * BULLET_SPEED, Math.sin(bullet.getRotation()) * BULLET_SPEED)
  )

check_bullets = ->
  _.each(bullets_arr, (bullet) ->
    if is_bullet_outside(bullet)
      bullets_arr.splice(bullets_arr.indexOf(bullet), 1)
      bullet.destroy()
  )

is_bullet_outside = (bullet) ->
  if bullet.getX() < 0 || bullet.getX() > WIDTH
    return true
  if bullet.getY() < 0 || bullet.getY() > HEIGHT
    return true
  false

ship_animation = new Kinetic.Animation (frame) ->
  if ship && !game_over
    move_ship()
    rotate_ship(frame)
    fix_position()
    move_bullets()
    check_bullets()
    _.each(bullets_arr, (bullet) ->
      check_bullet_col_asteroids(bullet)
    )
    check_ship_col_rock()
    animate_rocks(frame)
    fix_rocks_position()
    generate_rocks(frame)

check_bullet_col_asteroids = (bullet) ->
  _.each(rocks_arr, (rock) ->
    distance = get_hypotenuse(bullet.getX() - rock.getX(), bullet.getY() - rock.getY())
    if distance <= ROCK_RADIUS
      explode_rock(rock, bullet)
      points += 10
      $("#score").html("Score: " + points)
  )

remove_bullet = (bullet) ->
  if bullet
    index = bullets_arr.indexOf(bullet)
    bullet.destroy()
    bullets_arr.splice(index, 1)

remove_rock = (rock) ->
  if rock
    index = rocks_arr.indexOf(rock)
    rock.destroy()
    rocks_arr.splice(index, 1)
    rocks_dir.splice(index, 1)

explode_rock = (rock, bullet) ->
  explosion.setPosition(rock.getX(), rock.getY())
  explosion.setAnimation("explosion")
  remove_bullet(bullet)
  remove_rock(rock)

explode_rock_ship = (rock) ->
  remove_rock(rock)
  ship.destroy()
  game_over = true
  $("#game_over").html("GAME OVER")

check_ship_col_rock = ->
  if ship
    _.each(rocks_arr, (rock) ->
      distance = get_hypotenuse(rock.getX() - ship.getX(), rock.getY() - ship.getY())
      if distance <= ROCK_RADIUS + 30
        explode_rock_ship(rock)
    )

generate_rocks = (frame) ->
  if rocks_start == 0 || frame.time - rocks_start > rocks_interval
    rocks_start = frame.time
    randomX = Math.random() * WIDTH
    randomY = Math.random()
    if randomY < 0.5
      randomY = 0
    else
      randomY = HEIGHT
    createRock(randomX, randomY)

ship_animation.start()

stage.add(backgroundLayer)
stage.add(gameLayer)

document.onkeydown = (event) ->
  switch event.keyCode
    # rotate to the left
    when 37, 65
      set_rotation(-1)
    # up
    when 38, 87
      set_acceleration(.2)
    # rotate to the right
    when 39, 68
      set_rotation(1)
    # down
    when 40, 83
      console.log "down"
    # space bar
    when 32
      ship_shoot()
    else
      end_thrust()
  event.preventDefault()

document.onkeyup = (event) ->
  switch event.keyCode
    when 38, 87
      end_thrust()
    when 37, 65
      set_rotation(0)
    when 39, 68
      set_rotation(0)