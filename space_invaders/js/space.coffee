BLOCK_SIZE = 4
WIDTH_BLOCKS = 184
HEIGHT_BLOCKS = 181
WIDTH = WIDTH_BLOCKS * BLOCK_SIZE
HEIGHT = HEIGHT_BLOCKS * BLOCK_SIZE

stage = new Kinetic.Stage({
  container: "container"
  width: WIDTH
  height: HEIGHT
})

layer = new Kinetic.Layer()

animations =
  alien01: [
    {
      x: 4
      y: 4
      width: 48
      height: 32
    }
    {
      x: 56
      y: 4
      width: 48
      height: 32
    }
  ]
  alien02: [
    {
      x: 4
      y: 40
      width: 44
      height: 32
    }
    {
      x: 52
      y: 40
      width: 44
      height: 32
    }
  ]
  alien03: [
    {
      x: 4
      y: 72
      width: 32
      height: 32
    }
    {
      x: 40
      y: 72
      width: 32
      height: 32
    }
  ]

imageObj = new Image()
imageObj.onload = ->
  alien01 = new Kinetic.Sprite
    x: 10
    y: 10
    image: imageObj
    animation: 'alien01'
    animations: animations
    frameRate: 2

  layer.add(alien01)

  alien02 = new Kinetic.Sprite
    x: 10
    y: 46
    image: imageObj
    animation: 'alien02'
    animations: animations
    frameRate: 2

  layer.add(alien02)

  alien03 = new Kinetic.Sprite
    x: 10
    y: 82
    image: imageObj
    animation: 'alien03'
    animations: animations
    frameRate: 2

  layer.add(alien03)

  stage.add(layer)
  alien01.start()
  alien02.start()
  alien03.start()

imageObj.src = "img/aliens_all_small2.png"