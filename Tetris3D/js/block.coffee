window.Tetris = {}

class Tetris.Block
  constructor: (@x, @y, @z) ->
    @color = 0xFF0000
    @active = false
    @cube = null

  setColor: (color) ->
    @color = color

  draw: ->
    @active = true
    @cube = new THREE.SceneUtils.createMultiMaterialObject(
      new THREE.CubeGeometry(BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)
      [
        new THREE.MeshBasicMaterial({color: 0xFFAA00, wireframe: true, transparent: true })
        new THREE.MeshBasicMaterial({color: @color})
      ]
    )
    @calculate_pos()
    scene.add(@cube)

  print: -> console.log(@cube.position.x + ", " + @cube.position.y + ", " + @cube.position.z)

  calculate_pos: ->
    @cube.position.x = (TABLE_WIDTH / 2 + (@x - (TABLE_WIDTH - 0.5))) * BLOCK_SIZE
    @cube.position.y = -(TABLE_HEIGHT / 2 + (@y - (TABLE_HEIGHT - 0.5))) * BLOCK_SIZE
    @cube.position.z = (@z - TABLE_DEPTH / 2 + 0.5) * BLOCK_SIZE

  erase: ->
    @active = false
    scene.remove(@cube)