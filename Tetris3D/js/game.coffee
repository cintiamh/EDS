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

# array of static blocks
static_blocks = []

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

createMovingBlock = ->
  block = new THREE.SceneUtils.createMultiMaterialObject(
    new THREE.CubeGeometry(BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)
    [
      new THREE.MeshBasicMaterial({color: 0xFFFFFF, wireframe: true, transparent: true })
      new THREE.MeshBasicMaterial({color: 0xFFFFFF, transparent: true, opacity: 0.5})
    ]
  )
  scene.add(block)
  block.position.z = -0.5 * BLOCK_SIZE
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
  block2

moveBlockX = (block, value) ->
  temp = block.position.x + value * BLOCK_SIZE
  if temp >= -3 * BLOCK_SIZE && temp <= 3 * BLOCK_SIZE
    block.position.x = temp

moveBlockY = (block, value) ->
  temp = block.position.y + value * BLOCK_SIZE
  if temp >= -3 * BLOCK_SIZE && temp <= 3 * BLOCK_SIZE
    block.position.y = temp

moveBlockZ = (block) ->
  temp = block.position.z - BLOCK_SIZE
  if temp >= -14.5 * BLOCK_SIZE
    block.position.z = temp


block1 = createMovingBlock()
block2 = createSolidBlock(BLOCK_SIZE * 3, BLOCK_SIZE * 3, -14.5 * BLOCK_SIZE)
block3 = createSolidBlock(BLOCK_SIZE * 3, BLOCK_SIZE * 3, -0.5 * BLOCK_SIZE)

window.$(document).ready ->
  window.$(document).keydown (e) ->
    switch e.keyCode
      when 37, 65
      # left arrow - a
        moveBlockX(block1, -1)
      when 38, 87
      # up arrow - w
        moveBlockY(block1, 1)
      when 39, 68
      # right arrow - d
        moveBlockX(block1, 1)
      when 40
        #down arrow
        moveBlockY(block1, -1)
      when 32
        moveBlockZ(block1)


# Rendering scene
camera.position.z = DEPTH - 54 - BLOCK_SIZE * 6;

render = ->
  requestAnimationFrame(render)
  renderer.render(scene, camera)

render()