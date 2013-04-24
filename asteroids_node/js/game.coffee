class Game.Main
  constructor: (@width, @height) ->
    @stage = new Kinetic.Stage({
      container: "container"
      width: @width
      height: @height
    })
    @backgroundLayer = new Kinetic.Layer
    @starsLayer = new Kinetic.Layer
    @shipLayer = new Kinetic.Layer
    @ship = null

  createBackground: ->
    @backgroundLayer.add new Kinetic.Rect
      x: 0
      y: 0
      width: @width
      height: @height
      fill: "#000000"

  createStars: (number) ->
    starsGroup = new Kinetic.Group

    for n in [0..number]
      starsGroup.add new Kinetic.Star
        x: Math.random() * @width
        y: Math.random() * @height
        numPoints: 5
        innerRadius: Math.random() + 0.5
        outerRadius: Math.random() * 2 + 1.5
        fill: "#FFFFAA"
    @starsLayer.add starsGroup



  addShip: (x, y) ->
    @ship1 = new Game.Ship(x, y)
    @shipLayer.add(@ship1.ship)
    @ship1

  start: ->
    @stage.add(@backgroundLayer)
    @stage.add(@starsLayer)
    @stage.add(@shipLayer)


