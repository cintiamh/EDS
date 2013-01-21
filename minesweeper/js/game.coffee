# constants
BLOCK_SIZE = 30
REFRESH_RATE = 120 # ms

# global variables
canvas = document.getElementById('game') #$('#game').val()
context = canvas.getContext("2d")
running = false
time = 0
level = 0
levels = [
  {
    x: 8
    y: 8
    bombs: 10
  },
  {
    x: 16
    y: 16
    bombs: 40
  },
  {
    x: 31
    y: 16
    bombs: 99
  }
]
width = levels[level].x * BLOCK_SIZE
height = levels[level].y * BLOCK_SIZE
bombs = levels[level].bombs
bombsList = []
flagsList = []
showedList = []
numColors = ["#0000FF", "#008040", "#FF0000", "#000080", "#800040", "#408080", "#000000", "#808080"]
mousePos = {}
grid = []

getMousePos = (canvas, evt) ->
  rect = canvas.getBoundingClientRect()
  return {
    x: Math.floor((evt.clientX - rect.left) / BLOCK_SIZE)
    y: Math.floor((evt.clientY - rect.top) / BLOCK_SIZE)
  }

# Event listeners for the mouse clicks.
canvas.addEventListener(
  'click'
  (evt) ->
    evt.preventDefault()
    mousePos = getMousePos(canvas, evt)
    flipPiece(mousePos.x, mousePos.y)
    return false
  false
)

canvas.addEventListener(
  'contextmenu'
  (evt) ->
    evt.preventDefault()
    mousePos = getMousePos(canvas, evt)
    #drawFlag(mousePos.x, mousePos.y)
    putFlag(mousePos.x, mousePos.y)
    return false
  false
)

# function called when a square is clicked.
flipPiece = (x, y) ->
  drawDownButton(x, y)
  drawCharacter(x, y, "1", "#0000FF")
  unless running
    start()
    generateBombs(x, y)

drawFlag = (x, y) ->

  unless running
    start()
    generateBombs(x, y)

# When the player chooses a new levels, sets up all the variables for a new game.
setNewLevel = (l) ->
  if l < levels.length
    level = l
    width = levels[level].x * BLOCK_SIZE
    height = levels[level].y * BLOCK_SIZE
    bombs = levels[level].bombs
    canvas.width = width
    canvas.height = height

drawLine = (startX, startY, endX, endY, color, lineWidth) ->
  context.beginPath()
  context.moveTo(startX, startY)
  context.lineTo(endX, endY)
  context.lineWidth = lineWidth
  context.strokeStyle = color
  context.stroke()

# draws a unclicked square.
drawUpButton = (x, y) ->
  drawSquareBack(x, y)
  lineWidth = 3
  drawLine(x * BLOCK_SIZE, y * BLOCK_SIZE + lineWidth / 2, (x + 1) * BLOCK_SIZE, (y * BLOCK_SIZE) + lineWidth / 2, "#FFFFFF", lineWidth)
  drawLine(x * BLOCK_SIZE + lineWidth / 2, y * BLOCK_SIZE, x * BLOCK_SIZE + lineWidth / 2, (y + 1) * BLOCK_SIZE, "#FFFFFF", lineWidth)
  drawLine((x + 1) * BLOCK_SIZE - lineWidth / 2, (y + 1) * BLOCK_SIZE, (x + 1) * BLOCK_SIZE - lineWidth / 2, y * BLOCK_SIZE, "#7B7B7B", lineWidth)
  drawLine((x + 1) * BLOCK_SIZE, (y + 1) * BLOCK_SIZE - lineWidth / 2, x * BLOCK_SIZE, (y + 1) * BLOCK_SIZE - lineWidth / 2, "#7B7B7B", lineWidth)

# draws the simple square when it s clicked
drawDownButton = (x, y) ->
  drawSquareBack(x, y)
  lineWidth = 1
  drawLine(x * BLOCK_SIZE, y * BLOCK_SIZE, (x + 1) * BLOCK_SIZE, (y * BLOCK_SIZE), "#7B7B7B", lineWidth)
  drawLine(x * BLOCK_SIZE, y * BLOCK_SIZE, x * BLOCK_SIZE, (y + 1) * BLOCK_SIZE, "#7B7B7B", lineWidth)
  drawLine((x + 1) * BLOCK_SIZE, (y + 1) * BLOCK_SIZE, (x + 1) * BLOCK_SIZE, y * BLOCK_SIZE, "#7B7B7B", lineWidth)
  drawLine((x + 1) * BLOCK_SIZE, (y + 1) * BLOCK_SIZE, x * BLOCK_SIZE, (y + 1) * BLOCK_SIZE, "#7B7B7B", lineWidth)

# redraws over to clean just one of the squares on the table.
drawSquareBack = (x, y) ->
  context.beginPath()
  context.rect(x * BLOCK_SIZE, y * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)
  context.fillStyle = "#BDBDBD"
  context.fill()

drawCharacter = (x, y, v, color) ->
  context.beginPath()
  context.font = "bold 18pt Arial"
  context.fillStyle = color
  context.lineWidth = 2
  context.fillText(v, x * BLOCK_SIZE + 7, (y + 1)  * BLOCK_SIZE - 6)

# draw the whole clean table
drawTable = ->
  context.beginPath()
  context.rect(0, 0, width, height)
  context.fillStyle = "#BDBDBD"
  context.fill()
  # draw grid
  for posx in [0..levels[level].x]
    for posy in [0..levels[level].y]
      drawUpButton(posx, posy)

# recreates a new list of bombs according to the level.
generateBombs = (x, y) ->
  bombsList = []
  bombs = 0
  while bombs < levels[level].bombs
    newX = Math.floor(Math.random() * levels[level].x)
    newY = Math.floor(Math.random() * levels[level].y)
    # unless the new coordinates are new and are not the first click pos, add new bomb to list
    unless findBombInList(newX, newY) or (newX == x and newY == y)
      bombsList.push({x: newX, y: newY})
      bombs++
      console.log "x: " + newX + ", y: " + newY


putFlag = (x, y) ->
  if findFlagInList(x, y)
    console.log("remove flag")
    index = flagsList.indexOf({x: x, y: y})
    console.log(index + ", x: " + x + ", y: " + y)
    flagsList.splice(index, 1)
    drawSquareBack(x, y)
    drawUpButton(x, y)
  else
    console.log("put flag")
    flagsList.push({
      x: x
      y: y
    })
    drawCharacter(x, y, "F", "#FF0000")
  console.log flagsList

findFlagInList = (x, y) ->
  for flag in flagsList
    if flag.x == x and flag.y == y
      return true
  return false

# verifies if the pair of coordinates already exists in the list
findBombInList = (x, y) ->
  for bomb in bombsList
    if bomb.x == x and bomb.y == y
      return true
  return false

start = ->
  running = true
  flagsList = []

prepareCanvas = ->
  setNewLevel(0)
  drawTable()

prepareCanvas()
