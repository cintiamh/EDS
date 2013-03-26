window.Game = {}

class Game.Main
  constructor: (@width, @height) ->
    @stage = new Kinetic.Stage
      container: 'container'
      width: @width
      height: @height
    @layers = []
    @ships = []

  createBackground: ->
    @layers.push new Kinetic.Layer
    @layers[@layers.length - 1].add new Kinetic.Rect
      x: 0
      y: 0
      width: @width
      height: @height
      fill: "#000000"

  createStars: (number) ->
    @layers.push new Kinetic.Layer
    starsGroup = new Kinetic.Group

    for n in [0..number]
      starsGroup.add new Kinetic.Star
        x: Math.random() * @width
        y: Math.random() * @height
        numPoints: 5
        innerRadius: Math.random() + 0.5
        outerRadius: Math.random() * 2 + 1.5
        fill: "#FFFFAA"
    @layers[@layers.length - 1].add starsGroup

  addShip: (x, y) ->
    @layers.push new Kinetic.Layer
    @ships.push new Game.Ship(x, y)
    @layers[@layers.length - 1].add @ships[@ships.length - 1].ship

  start: ->
    for layer in @layers
      @stage.add(layer)


