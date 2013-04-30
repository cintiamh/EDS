class window.Canon
  constructor: (@x, @y, @imgObj, @layer) ->
    @velocity = 15
    animations =
      canon: [
        x: 3
        y: 111
        width: 45
        heigth: 24
      ]
    @sprite = new Kinetic.Sprite
      x: @x
      y: @y
      image: @imgObj
      animation: 'canon'
      animations: animations
      frameRate: 7
      index: 0
    @layer.add(@sprite)
