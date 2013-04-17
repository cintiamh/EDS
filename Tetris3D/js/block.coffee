window.Tetris = {}

class Tetris.Block
  constructor: (@size) ->
    @moving = false
    @static_colors = [0x0000FF, 0x3333FF, 0x6565FF, 0x9999FF, 0xB2B2FF, 0xCBCBFF, 0xE5E5FF,
                      0xE5FFE5, 0xCBFFCB, 0xB2FFB2, 0x99FF99, 0x65FF65, 0x33FF33, 0x00FF00]
    @moving_color = [0xFFFFFF]
    @cube = new THREE.SceneUtils.createMultiMaterialObject(
      new THREE.CubeGeometry(@size, @size, @size)
      [
        new THREE.MeshBasicMaterial({color: 0xFFFFFF, wireframe: true, transparent: true })
        new THREE.MeshBasicMaterial({color: 0xFF0000, transparent: true, opacity: 0.5})
      ]
    )
    console.log @cube

  setColor: (color) ->
    @color = color

  print: -> console.log(@cube.position.x + ", " + @cube.position.y + ", " + @cube.position.z)

  erase: ->
    @active = false
    scene.remove(@cube)