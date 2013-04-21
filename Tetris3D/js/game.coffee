# Parameters
BLOCK_SIZE = 100
TABLE_WIDTH = 7
TABLE_HEIGHT = 7
TABLE_DEPTH = 15

WIDTH = BLOCK_SIZE * TABLE_WIDTH
HEIGHT = BLOCK_SIZE * TABLE_HEIGHT
DEPTH = BLOCK_SIZE * TABLE_DEPTH

MAX_DEPTH = -0.5 * BLOCK_SIZE
MIN_DEPTH = -14.5 * BLOCK_SIZE
MAX_SIDE = 3 * BLOCK_SIZE
MIN_SIDE = -3 * BLOCK_SIZE

# Camera Attributes
VIEW_ANGLE = 45
ASPECT = WIDTH / HEIGHT
NEAR = 0.1
FAR = 10000

# instantiated shape
shape = null

# array of static blocks
static_blocks = []

level = 0
intervals = [1000, 900, 800, 700, 600, 500, 400, 300, 200, 100]
timer = 0
points = 0

shapes = [
  # bar
  [{x:0, y:-1, z:0}, {x:0, y:0, z:0}, {x:0, y:1, z:0}, {x:0, y:2, z:0}]
  # mountain
  [{x:-1, y:0, z:0}, {x:0, y:0, z:0}, {x:1, y:0, z:0}, {x:0, y:1, z:0}]
  # L
  [{x:0, y:0, z:0}, {x:0, y:1, z:0}, {x:1, y:0, z:0}, {x:2, y:0, z:0}]
  # S
  [{x:-1, y:0, z:0}, {x:0, y:0, z:0}, {x:0, y:1, z:0}, {x:1, y:1, z:0}]
  # 3D shapes
  [{x:-1, y:0, z:-1}, {x:0, y:0, z:-1}, {x:0, y:-1, z:-1}, {x:0, y:-1, z:0}]
  [{x:-1, y:0, z:-1}, {x:0, y:0, z:-1}, {x:0, y:1, z:-1}, {x:0, y:1, z:0}]
  [{x:-1, y:0, z:-1}, {x:0, y:0, z:-1}, {x:0, y:-1, z:-1}, {x:0, y:0, z:0}]
]
static_colors = [
  0xFFFFFF, 0xC0C0C0, 0x800000, 0xFF0000, 0x800000, 0xFFFF00, 0x808000,
  0x00FF00, 0x008000, 0x00FFFF, 0x008080, 0x0000FF, 0x000080, 0xFF00FF, 0x800080
]

# Creating basic structure for Three.js
scene = new THREE.Scene()
camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR)
renderer = new THREE.WebGLRenderer()
renderer.setSize(WIDTH, HEIGHT)
canvas = $('#canvas')
canvas.append(renderer.domElement)

# Creating bounding box for game
boundingBox = new THREE.Mesh(
  new THREE.CubeGeometry(WIDTH, HEIGHT, DEPTH * 2, TABLE_WIDTH, TABLE_HEIGHT, TABLE_DEPTH * 2)
  new THREE.MeshBasicMaterial({color: 0x999999, wireframe: true, wireframeLinewidth: 2})
)
scene.add(boundingBox)

createMovingBlock = (x, y, z) ->
  block = new THREE.SceneUtils.createMultiMaterialObject(
    new THREE.CubeGeometry(BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)
    [
      new THREE.MeshBasicMaterial({color: 0xFFFFFF, wireframe: true, transparent: true })
      new THREE.MeshBasicMaterial({color: 0xFFFFFF, transparent: true, opacity: 0.5})
    ]
  )
  scene.add(block)
  block.position.z = z * BLOCK_SIZE
  block.position.x = x * BLOCK_SIZE
  block.position.y = y * BLOCK_SIZE
  block

createSolidBlock = (x, y, z) ->
  block2 = new THREE.SceneUtils.createMultiMaterialObject(
    new THREE.CubeGeometry(BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)
    [
      new THREE.MeshBasicMaterial({color: 0x000000, wireframe: true, transparent: true })
      new THREE.MeshBasicMaterial({color: static_colors[Math.floor(Math.abs(z) / BLOCK_SIZE)]})
    ]
  )
  scene.add(block2)
  block2.position.x = x
  block2.position.y = y
  block2.position.z = z
  static_blocks.push(block2)

createShape = ->
  random_index = Math.floor(shapes.length * Math.random())
  scene.remove(shape)
  shape = new THREE.Object3D()
  for cube in shapes[random_index]
    shape.add(createMovingBlock(cube.x, cube.y, cube.z))
  shape.position.z -= 0.5 * BLOCK_SIZE
  scene.add(shape)

moveShape = (value_x, value_y) ->
  #if isInsideBox(value_x, value_y)
  if canShapeMove(value_x, value_y, 0)
    shape.position.x = shape.position.x + value_x * BLOCK_SIZE
    shape.position.y = shape.position.y + value_y * BLOCK_SIZE

moveShapeBack = ->
  if canShapeMove(0, 0, -1)
    shape.position.z = shape.position.z - BLOCK_SIZE
  else
    # freeze and destroy shape
    convertShapeToSolidBlocks()
    # verifies completed level
    checkCompletedLevel()
    # verifies game over
    if checkGameOver()
      console.log "Game Over"
    else
    # create a new shape
      createShape()

canShapeMove = (move_x, move_y, move_z) ->
  for cube in shape.children
    pos_x = cube.position.x + shape.position.x + move_x * BLOCK_SIZE
    pos_y = cube.position.y + shape.position.y + move_y * BLOCK_SIZE
    pos_z = cube.position.z + shape.position.z + move_z * BLOCK_SIZE
    solid_block = _.find(static_blocks, (block) -> return block.position.x == pos_x && block.position.y == pos_y && block.position.z == pos_z)
    if solid_block
      return false
    # checks if reached bottom
    else if pos_z < MIN_DEPTH
      return false
    else if pos_x < MIN_SIDE || pos_x > MAX_SIDE
      return false
    else if pos_y < MIN_SIDE || pos_y > MAX_SIDE
      return false
  true

convertShapeToSolidBlocks = ->
  for cube in shape.children
    createSolidBlock(cube.position.x + shape.position.x, cube.position.y + shape.position.y, cube.position.z + shape.position.z)
  scene.remove(shape)

checkGameOver = ->
  outbound_block = _.find(static_blocks, (block) -> return block.position.z > -0.5 * BLOCK_SIZE)
  if outbound_block
    return true
  false

rotateShape = (dirx, diry, dirz) ->
  unless dirx == 0
    for cube in shape.children
      temp = cube.position.y
      cube.position.y = -1 * cube.position.z
      cube.position.z = temp

  unless diry == 0
    for cube in shape.children
      temp = cube.position.x
      cube.position.x = cube.position.z
      cube.position.z = -1 * temp

  unless dirz == 0
    for cube in shape.children
      temp = cube.position.x
      cube.position.x = -1 * cube.position.y
      cube.position.y = temp

  calculateExcess()

calculateExcess = ->
  excess = {x: 0, y: 0}
  max_value = 3 * BLOCK_SIZE
  for cube in shape.children
    pos_x = cube.position.x + shape.position.x
    pos_y = cube.position.y + shape.position.y
    if Math.abs(pos_x) > max_value
      excess.x = Math.abs(pos_x) - max_value
      if pos_x > 0
        excess.x = -1 * excess.x
    if Math.abs(pos_y) > max_value
      excess.y = Math.abs(pos_y) - max_value
      if pos_y > 0
        excess.y = -1 * excess.y
  shape.position.x = shape.position.x + excess.x
  shape.position.y = shape.position.y + excess.y

checkCompletedLevel = ->
  level = MIN_DEPTH / BLOCK_SIZE
  num_levels = (MAX_DEPTH - MIN_DEPTH) / BLOCK_SIZE
  for num in [0..num_levels]
    level_arr = _.filter(static_blocks, (block) -> return block if block.position.z == level * BLOCK_SIZE)
    if level_arr.length >= TABLE_HEIGHT * TABLE_WIDTH
      addPoints(50)
      eliminateCompletedLevel(level)
    else
      level = level + 1

eliminateCompletedLevel = (level) ->
  pos_z = MIN_DEPTH - level * BLOCK_SIZE
  level_arr = _.filter(static_blocks, (block) -> return block if block.position.z == pos_z)
  above_arr = _.filter(static_blocks, (block) -> return block if block.position.z > pos_z)
  for cube in level_arr
    indexOfCube = static_blocks.indexOf(cube)
    static_blocks.splice(indexOfCube, 1)
    scene.remove(cube)
  for cube in above_arr
    cube.position.z -= BLOCK_SIZE
    cube.children[1].material.color.setHex(static_colors[Math.floor(Math.abs(cube.position.z) / BLOCK_SIZE)])

addPoints = (n) ->
  points += n
  level = Math.floor(points/1000)
  document.getElementById("score").innerHTML = points

window.$(document).ready ->
  window.$(document).keydown (e) ->
    switch e.keyCode
      # left arrow
      when 37
        moveShape(-1, 0)
      # up arrow
      when 38
        moveShape(0, 1)
      # right arrow
      when 39
        moveShape(1, 0)
      # down arrow
      when 40
        moveShape(0, -1)
      # space bar
      when 32
        moveShapeBack()
      # q
      when 81
        rotateShape(1, 0, 0)
      # w
      when 87
        rotateShape(0, 1, 0)
      # e
      when 69
        rotateShape(0, 0, 1)
      # a
      when 65
        rotateShape(-1, 0, 0)
      # s
      when 83
        rotateShape(0, -1, 0)
      # d
      when 68
        rotateShape(0, 0, -1)


# Rendering scene
camera.position.z = DEPTH - 54 - BLOCK_SIZE * 6;

render = ->
  requestAnimationFrame(render)
  renderer.render(scene, camera)

createShape()
render()

unless checkGameOver()
  setInterval(moveShapeBack, intervals[level])

  ###
for num1 in [-3..3]
  for num2 in [-3..3]
    createSolidBlock(num1 * BLOCK_SIZE, num2 * BLOCK_SIZE, -14.5 * BLOCK_SIZE)

for num1 in [-3..3]
  for num2 in [-3..3]
    createSolidBlock(num1 * BLOCK_SIZE, num2 * BLOCK_SIZE, -13.5 * BLOCK_SIZE)


###