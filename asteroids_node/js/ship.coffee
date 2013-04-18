class Game.Ship
  constructor: (@x, @y, color = "#42B4E6") ->
    @max_speed = 4
    @drag = 0.01
    @ship = new Kinetic.Group
    @ship.add new Kinetic.Polygon
      points:[-15, -10, 15, 0, -15, 10]
      sides: 3
      radius: 10
      fill: color
    @velocity = { x: 0, y: 0 }
    @acceleration = 0
    @setPosition(@x, @y)
    @rotation = 0
    #@animation = null

  setPosition: (@x, @y) ->
    @ship.setX(@x)
    @ship.setY(@y)

  setAcceleration: (val) ->
    @acceleration += val
    console.log "set acceleration " + @acceleration

  setRotation: (val) ->
    @rotation = val
    console.log "set rotation " + @rotation

  getHypotenuse: (x, y) ->
    Math.sqrt(x * x + y * y)

  rotate: (frame, dir) ->
    #console.log "rotate"
    angularSpeed = Math.PI / 2
    angleDiff = frame.timeDiff * angularSpeed / 1000
    @ship.rotate(dir * angleDiff)

  #createAnimation: ->
  #  @animation = new Kinetic.Animation (frame) ->
  #    @rotate(frame, @rotation)
  #    @moveShip()

  moveShip: ->
    #console.log "move Ship"
    if @acceleration != 0
      movementAngle = @ship.getRotation()
      @velocity.x += Math.cos(movementAngle) * @acceleration
      @velocity.y += Math.sin(movementAngle) * @acceleration
      @acceleration = 0

    speed = @getHypotenuse(@velocity.x, @velocity.y)

    if speed > @max_speed
      speed = @max_speed
    else if speed > 0
      speed -= @drag

    speedAngle = Math.atan2(@velocity.y, @velocity.x)
    @velocity.x = Math.cos(speedAngle) * speed
    @velocity.y = Math.sin(speedAngle) * speed

    @ship.move(@velocity.x, @velocity.y)

  #startAnimation: ->
  #  @animation.start()