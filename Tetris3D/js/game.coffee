# Parameters
BLOCK_SIZE = 100
TABLE_WIDTH = 7
TABLE_HEIGHT = 7
TABLE_DEPTH = 15

WIDTH = BLOCK_SIZE * TABLE_WIDTH
HEIGHT = BLOCK_SIZE * TABLE_HEIGHT
DEPTH = BLOCK_SIZE * TABLE_DEPTH

# Camera Attributes
VIEW_ANGLE = 45
ASPECT = WIDTH / HEIGHT
NEAR = 0.1
FAR = 10000

# instantiated shape
shape = null

# array of static blocks
static_blocks = []

shapes = [
  # bar
  [{x:0, y:-1, z:0}, {x:0, y:0, z:0}, {x:0, y:1, z:0}, {x:0, y:2, z:0}]
  # mountain
  [{x:-1, y:0, z:0}, {x:0, y:0, z:0}, {x:1, y:0, z:0}, {x:0, y:1, z:0}]
  # L
  [{x:-1, y:0, z:0}, {x:0, y:0, z:0}, {x:1, y:0, z:0}, {x:-1, y:1, z:0}]
  # S
  [{x:-1, y:0, z:0}, {x:0, y:0, z:0}, {x:0, y:1, z:0}, {x:1, y:1, z:0}]
  # 3D shapes
  [{x:-1, y:0, z:0}, {x:0, y:0, z:0}, {x:0, y:-1, z:0}, {x:0, y:-1, z:1}]
  [{x:-1, y:0, z:0}, {x:0, y:0, z:0}, {x:0, y:1, z:0}, {x:0, y:1, z:1}]
  [{x:-1, y:0, z:0}, {x:0, y:0, z:0}, {x:0, y:-1, z:0}, {x:0, y:0, z:1}]
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
  block.position.z = (z - 0.5) * BLOCK_SIZE
  block.position.x = x * BLOCK_SIZE
  block.position.y = y * BLOCK_SIZE
  block

createSolidBlock = (x, y, z) ->
  static_colors = [0x00FFFF, 0x0000FF, 0x3333FF, 0x6565FF, 0x9999FF, 0xB2B2FF, 0xCBCBFF, 0xE5E5FF,
                   0xE5FFE5, 0xCBFFCB, 0xB2FFB2, 0x99FF99, 0x65FF65, 0x33FF33, 0x00FF00]
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
  console.log static_blocks

createShape = ->
  random_index = Math.floor(shapes.length * Math.random())
  scene.remove(shape)
  shape = new THREE.Object3D()
  for cube in shapes[random_index]
    shape.add(createMovingBlock(cube.x, cube.y, cube.z))
  scene.add(shape)

moveShape = (value_x, value_y) ->
  if isInsideBox(value_x, value_y)
    shape.position.x = shape.position.x + value_x * BLOCK_SIZE
    shape.position.y = shape.position.y + value_y * BLOCK_SIZE

moveShapeBack = ->
  unless gotToBottom()
    shape.position.z = shape.position.z - BLOCK_SIZE

isInsideBox = (move_x, move_y) ->
  for cube in shape.children
    pos_x = cube.position.x + shape.position.x
    pos_y = cube.position.y + shape.position.y
    if move_x < 0 && pos_x <= -3 * BLOCK_SIZE
      return false
    else if move_x > 0 && pos_x >= 3 * BLOCK_SIZE
      return false
    if move_y < 0 && pos_y <= -3 * BLOCK_SIZE
      return false
    else if move_y > 0 && pos_y >= 3 * BLOCK_SIZE
      return false
  true

gotToBottom = ->
  for cube in shape.children
    pos_z = cube.position.z + shape.position.z - BLOCK_SIZE
    # check if reached the bottom of table
    if pos_z < -14.5 * BLOCK_SIZE
      return true
    # check if collided with a solid cube
    neighbor = _.find(static_blocks, (block) -> return block.position.x == cube.position.x && block.position.y == cube.position.y && block.position.z == cube.position.z)
    if neighbor
      return true
  false


#block1 = createMovingBlock()
block2 = createSolidBlock(BLOCK_SIZE * 3, BLOCK_SIZE * 3, -14.5 * BLOCK_SIZE)
block3 = createSolidBlock(BLOCK_SIZE * 3, BLOCK_SIZE * 3, -0.5 * BLOCK_SIZE)
createShape()
console.log shape

window.$(document).ready ->
  window.$(document).keydown (e) ->
    switch e.keyCode
      when 37, 65
      # left arrow - a
        moveShape(-1, 0)
      when 38, 87
      # up arrow - w
        moveShape(0, 1)
      when 39, 68
      # right arrow - d
        moveShape(1, 0)
      when 40
        #down arrow
        moveShape(0, -1)
      when 32
        moveShapeBack()


# Rendering scene
camera.position.z = DEPTH - 54 - BLOCK_SIZE * 6;

render = ->
  requestAnimationFrame(render)
  renderer.render(scene, camera)

render()