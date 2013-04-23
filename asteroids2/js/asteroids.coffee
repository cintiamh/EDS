WIDTH = 800
HEIGHT = 600

score = 0
lives = 3
time = 0
rot_speed = 0.1

angle_to_vector = (angle) ->
  [Math.cos(angle), Math.sin(angle)]

distance = (initial, final) ->
  diffx = initial[0] - final[0]
  diffy = initial[1] - final[1]
  Math.sqrt(diffx * diffx + diffy * diffy)

window.onload = ->
  stage = new Kinetic.Stage({
    container: 'container'
    width: 328
    height: 200
  })
  console.log stage

  layer = new Kinetic.Layer()

  rect = new Kinetic.Rect({
    x: 239,
    y: 75,
    width: 100,
    height: 50,
    fill: 'green',
    stroke: 'black',
    strokeWidth: 4
  })

  layer.add(rect)

  stage.add(layer)