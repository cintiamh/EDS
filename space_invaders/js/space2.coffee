BLOCK_SIZE = 3
WIDTH_NUM_BLOCKS = 184
HEIGHT_NUM_BLOCKS = 191
WIDTH = WIDTH_NUM_BLOCKS * BLOCK_SIZE
HEIGHT = HEIGHT_NUM_BLOCKS * BLOCK_SIZE

aliensArr = []
bulletsArr = []
canon = null

# aliens movement
alienSideMove = 2 * BLOCK_SIZE
alienDownMove = 6 * BLOCK_SIZE

# speeds
alienMovPause = 1
canonSpeed = 15
bulletSpeed = 20

stage = new Kinetic.Stage
  container: "container"
  width: WIDTH
  height: HEIGHT

backgroundLayer = new Kinetic.Layer

# Create a black background
background = new Kinetic.Rect
  x: 0
  y: 0
  width: WIDTH
  height: HEIGHT
  fill: "#000000"

backgroundLayer.add(background)

# Staging the background layer
stage.add(backgroundLayer)

aliensLayer = new Kinetic.Layer
canonLayer = new Kinetic.Layer

# Animations images mapping array for Sprites
animations =
  alien01: [
    x: BLOCK_SIZE
    y: BLOCK_SIZE
    width: 12 * BLOCK_SIZE
    height: 8 * BLOCK_SIZE
    ,
    x: 14 * BLOCK_SIZE
    y: BLOCK_SIZE
    width: 12 * BLOCK_SIZE
    height: 8 * BLOCK_SIZE
  ]
  alien02: [
    x: BLOCK_SIZE
    y: 10 * BLOCK_SIZE
    width: 11 * BLOCK_SIZE
    height: 8 * BLOCK_SIZE
    ,
    x: 13 * BLOCK_SIZE
    y: 10 * BLOCK_SIZE
    width: 11 * BLOCK_SIZE
    height: 8 * BLOCK_SIZE
  ]
  alien03: [
    x: BLOCK_SIZE
    y: 19 * BLOCK_SIZE
    width: 8 * BLOCK_SIZE
    height: 8 * BLOCK_SIZE
    ,
    x: 10 * BLOCK_SIZE
    y: 19 * BLOCK_SIZE
    width: 8 * BLOCK_SIZE
    height: 8 * BLOCK_SIZE
  ]
  spaceship: [
    x: BLOCK_SIZE
    y: (3 * 8 + 4) * BLOCK_SIZE
    width: 16 * BLOCK_SIZE
    height: 8 * BLOCK_SIZE
  ]
  canon: [
    x: BLOCK_SIZE
    y: (4 * 8 + 5) * BLOCK_SIZE
    width: 15 * BLOCK_SIZE
    height: 8 * BLOCK_SIZE
  ]
  hidden: [
    x: 0
    y: 0
    width: 0
    height: 0
  ]

imageObj = new Image()
aliensGroup = new Kinetic.Group()

imageObj.onload = ->
  console.log("Testing")
  canon = new Kinetic.Sprite
    x: WIDTH / 2 - 7 * BLOCK_SIZE
    y: HEIGHT - 8 * BLOCK_SIZE
    image: imageObj
    animation: 'canon'
    animations: animations
    frameRate: 1

  console.log(canon)
  canonLayer.add(canon)
  stage.add(canonLayer)
  canon.start()





