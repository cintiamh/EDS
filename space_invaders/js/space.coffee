BLOCK_SIZE = 3
WIDTH_BLOCKS = 184
HEIGHT_BLOCKS = 181
WIDTH = WIDTH_BLOCKS * BLOCK_SIZE
HEIGHT = HEIGHT_BLOCKS * BLOCK_SIZE

aliensArr = []
startTime = 0
movCount = 0
movDirection = 1
movSideDist = 2 * BLOCK_SIZE
movDownDist = 6 * BLOCK_SIZE

stage = new Kinetic.Stage({
  container: "container"
  width: WIDTH
  height: HEIGHT
})

layer = new Kinetic.Layer()

background = new Kinetic.Rect
  x: 0
  y: 0
  width: WIDTH
  height: HEIGHT
  fill: "#000000"

layer.add(background)

# Animations images mapping array
animations =
  alien01: [
    {
      x: BLOCK_SIZE
      y: BLOCK_SIZE
      width: 12 * BLOCK_SIZE
      height: 8 * BLOCK_SIZE
    }
    {
      x: 14 * BLOCK_SIZE
      y: BLOCK_SIZE
      width: 12 * BLOCK_SIZE
      height: 8 * BLOCK_SIZE
    }
  ]
  alien02: [
    {
      x: BLOCK_SIZE
      y: 10 * BLOCK_SIZE
      width: 11 * BLOCK_SIZE
      height: 8 * BLOCK_SIZE
    }
    {
      x: 13 * BLOCK_SIZE
      y: 10 * BLOCK_SIZE
      width: 11 * BLOCK_SIZE
      height: 8 * BLOCK_SIZE
    }
  ]
  alien03: [
    {
      x: BLOCK_SIZE
      y: 19 * BLOCK_SIZE
      width: 8 * BLOCK_SIZE
      height: 8 * BLOCK_SIZE
    }
    {
      x: 10 * BLOCK_SIZE
      y: 19 * BLOCK_SIZE
      width: 8 * BLOCK_SIZE
      height: 8 * BLOCK_SIZE
    }
  ]

imageObj = new Image()

aliensGroup = new Kinetic.Group()

imageObj.onload = ->

  for num1 in [0..4]
    for num2 in [0..10]
      if num1 == 0
        aliensArr.push(new Kinetic.Sprite
          x: BLOCK_SIZE + num2 * (12 + 2) * BLOCK_SIZE
          y: num1 * (8 + 6) * BLOCK_SIZE
          image: imageObj
          animation: 'alien03'
          animations: animations
          frameRate: 2
        )
      if num1 == 1 || num1 == 2
        aliensArr.push(new Kinetic.Sprite
          x: num2 * (12 + 2) * BLOCK_SIZE
          y: num1 * (8 + 6) * BLOCK_SIZE
          image: imageObj
          animation: 'alien02'
          animations: animations
          frameRate: 2
        )
      if num1 == 3 || num1 == 4
        aliensArr.push(new Kinetic.Sprite
          x: num2 * (12 + 2) * BLOCK_SIZE
          y: num1 * (8 + 6) * BLOCK_SIZE
          image: imageObj
          animation: 'alien01'
          animations: animations
          frameRate: 2
        )

  for alien in aliensArr
    #layer.add(alien)
    aliensGroup.add(alien)
    layer.add(aliensGroup)
    alien.start()

  aliensGroup.move(BLOCK_SIZE, BLOCK_SIZE)

stage.add(layer)

animation = new Kinetic.Animation((frame) ->
  if frame.time - startTime > 500
    startTime = frame.time
    if movCount % 16 == 15
      aliensGroup.move(0, movDownDist)
      movDirection *= -1
    else
      aliensGroup.move(movDirection * movSideDist, 0)
    movCount++
)

animation.start()

imageObj.src = "img/aliens_all.png"