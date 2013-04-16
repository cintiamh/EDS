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


# Rendering scene
camera.position.z = DEPTH - 54 - BLOCK_SIZE * 6;

render = ->
  requestAnimationFrame(render)
  renderer.render(scene, camera)

render()