class Game.Rock
  constructor: (@x, @y, @imageObj) ->
    animations = {
      idle: [{
        x: 0
        y: 0
        width: 90
        height: 90
      }]
    }
    @rock_obj = new Kinetic.Sprite({
      x: @x
      y: @y
      image: imageObj
      animation: animations
      frameRate: 7
      index: 0
    })
    @rock_obj.setOffset(45, 45)
    @velocity = {x: 0, y: 0}
    @acceleration = 0
    @rotation = 0
    #@rock_obj.setAnimation('idle')

  moveRock: ->
    @rock_obj.move(Math.cos(@rock_obj.getRotation()) * Game.ROCK_SPEED, Math.sin(@rock_obj.getRotation()) * Game.ROCK_SPEED)