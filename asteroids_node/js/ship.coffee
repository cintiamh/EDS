class Game.Ship
  constructor: (@x, @y, @imageObj) ->
    animations = {
      idle: [{
        x: 3
        y: 12
        width: 80
        height: 65
      }]
      thrust: [{
        x: 95
        y: 12
        width: 80
        height: 65
      }]
    }
    @ship_obj = new Kinetic.Sprite({
      x: @x
      y: @y
      image: imageObj
      animation: 'idle'
      animations: animations
      frameRate: 7
      index: 0
    })
    @ship_obj.setOffset(40, 30)
    @velocity = { x: 0, y: 0 }
    @acceleration = 0
    @rotation = 0
    @bullets = []

  setThrust: ->
    @ship_obj.setAnimation('thrust')

  endThrust: ->
    @ship_obj.setAnimation('idle')

  setAcceleration: (val) ->
    @acceleration += val
    @setThrust()

  setRotation: (val) ->
    @rotation = val

  getHypotenuse: (x, y) ->
    Math.sqrt(x * x + y * y)

  rotate: (frame) ->
    angularSpeed = Math.PI / 2
    angleDiff = frame.timeDiff * angularSpeed / 1000
    @ship_obj.rotate(@rotation * angleDiff)

  moveShip: ->
    if @acceleration != 0
      movementAngle = @ship_obj.getRotation()
      @velocity.x += Math.cos(movementAngle) * @acceleration
      @velocity.y += Math.sin(movementAngle) * @acceleration
      @acceleration = 0

    speed = @getHypotenuse(@velocity.x, @velocity.y)

    if speed > Game.SHIP_MAX_VEL
      speed = Game.SHIP_MAX_VEL
    else if speed > 0
      speed -= Game.SHIP_DRAG

    speedAngle = Math.atan2(@velocity.y, @velocity.x)
    @velocity.x = Math.cos(speedAngle) * speed
    @velocity.y = Math.sin(speedAngle) * speed

    @ship_obj.move(@velocity.x, @velocity.y)

  fixPosition: ->
    if @ship_obj.getX() <= 0
      @ship_obj.setX(Game.WIDTH)
    else if @ship_obj.getX() >= Game.WIDTH
      @ship_obj.setX(0)
    if @ship_obj.getY() <= 0
      @ship_obj.setY(Game.HEIGHT)
    else if @ship_obj.getY() >= Game.HEIGHT
      @ship_obj.setY(0)

  createBullet: (layer) ->
    bullet = new Kinetic.Rect({
      x: @ship_obj.getX()
      y: @ship_obj.getY()
      width: 8
      height: 4
      fill: '#00FFFF'
    })
    bullet.setRotation(@ship_obj.getRotation())
    bullet.move(Math.cos(@ship_obj.getRotation()) * 40, Math.sin(@ship_obj.getRotation()) * 40)
    layer.add(bullet)
    @bullets.push(bullet)

  moveBullets: ->
    for bullet in @bullets
      if bullet
        bullet.move(Math.cos(bullet.getRotation()) * Game.BULLET_SPEED, Math.sin(bullet.getRotation()) * Game.BULLET_SPEED)

  # Check if bullet is out of the screen
  checkBullets: ->
    for bullet in @bullets
      if bullet && @isBulletOutside(bullet)
        @bullets.splice(@bullets.indexOf(bullet), 1)
        bullet.destroy()

  isBulletOutside: (bullet) ->
    if bullet.getX() < 0 || bullet.getX() > Game.WIDTH
      return true
    if bullet.getY() < 0 || bullet.getY() > Game.HEIGHT
      return true
    false
