# constants
BLOCK_SIZE = 30
REFRESH_RATE = 120 # ms

# global variables
canvas = document.getElementById('game')
context = canvas.getContext "2d"
running = false
exploded = false
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
flippedList = []
numColors = ["#0000FF", "#008040", "#FF0000", "#000080", "#800040", "#408080", "#000000", "#808080"]
mousePos = {}
tileNeighbors = (inX, inY) ->
  [
    { x: inX - 1, y: inY - 1}
    { x: inX - 1, y: inY}
    { x: inX - 1, y: inY + 1}
    { x: inX, y: inY - 1}
    { x: inX, y: inY + 1}
    { x: inX + 1, y: inY - 1}
    { x: inX + 1, y: inY}
    { x: inX + 1, y: inY + 1}
  ]

# Draw functions
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

# Mouse events
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
    putFlag mousePos.x, mousePos.y
    return false
  false
)

# function called when a square is left clicked.
flipPiece = (x, y) ->
  unless running
    start()
    generateBombs(x, y)
  unless (findItemInList(flagsList, x, y)) or exploded
    if (findItemInList(bombsList, x, y))
      # bomb explodes and game is over
      explodeBomb()
    else
      discoverTiles(x, y)

# Verifies the tile s neighbors
discoverTiles = (x, y) ->
  unless findItemInList(flippedList, x, y) or findItemInList(bombsList, x, y)
    drawDownButton(x, y)
    count = countBombs(x, y)
    flippedList.push {x: x, y: y}
    if count == 0
      discoverNeighbors(x, y)
    else
      drawCharacter(x, y, count, numColors[count - 1])

# Sets the end of game and draws all bombs
explodeBomb = ->
  exploded = true
  bombsList.map (bomb) ->
    drawDownButton(bomb.x, bomb.y)
    drawCharacter(bomb.x, bomb.y, "B", "#000000")

# Recursively visits all neighbors to check if it s empty or not
discoverNeighbors = (x, y) ->
  tileNeighbors(x, y).map (tile) ->
    if 0 <= tile.x < levels[level].x and 0 <= tile.y < levels[level].y
      discoverTiles(tile.x, tile.y)

# Counts the number of neighbors that are bombs
countBombs = (x, y) ->
  count = 0
  # count the number of neighbor bombs
  tileNeighbors(x, y).map (tile) ->
    if 0 <= tile.x < levels[level].x and 0 <= tile.y < levels[level].y
      if findItemInList(bombsList, tile.x, tile.y)
        count++
  return count

# To right click event, put a flag in place
putFlag = (x, y) ->
  unless findItemInList(flippedList, x, y)
    if findItemInList(flagsList, x, y)
      temp = []
      for flag in flagsList
        unless flag.x == x and flag.y == y
          temp.push(flag)
      flagsList = temp
      drawSquareBack(x, y)
      drawUpButton(x, y)
    else
      flagsList.push({
        x: x
        y: y
      })
      drawCharacter(x, y, "F", "#FF0000")
      bombs--
      updateBombs()

# When the player chooses a new levels, sets up all the variables for a new game.
setNewLevel = (l) ->
  if l < levels.length
    level = l
    width = levels[level].x * BLOCK_SIZE
    height = levels[level].y * BLOCK_SIZE
    bombs = levels[level].bombs
    canvas.width = width
    canvas.height = height

# recreates a new list of bombs according to the level.
generateBombs = (x, y) ->
  bombsList = []
  bombs = 0
  while bombs < levels[level].bombs
    newX = Math.floor(Math.random() * levels[level].x)
    newY = Math.floor(Math.random() * levels[level].y)
    # unless the new coordinates are new and are not the first click pos, add new bomb to list
    unless findItemInList(bombsList, newX, newY) or (newX == x and newY == y)
      bombsList.push({x: newX, y: newY})
      bombs++
  updateBombs()

findItemInList = (list, x, y) ->
  for item in list
    if item.x == x and item.y == y
      return true
  return false

start = ->
  running = true
  flagsList = []

prepareCanvas = ->
  setNewLevel(level)
  drawTable()

prepareCanvas()

setInterval(callTimer, 1000)

###
  Controlling external elements
  - Level Select
  - Remaining Bombs #
  - Clock
###

updateBombs = ->
  console.log("updateBombs: " + bombs)
  if bombs >= 0
    document.getElementById("bombs").innerHTML = bombs

callTimer = ->
  if running
    time++
    document.getElementById("time").innerHTML = convertNumToTimestamp(time)

convertNumToTimestamp = (t) ->
  sec = fixDecimal(Math.floor(t % 60))
  min = fixDecimal(Math.floor(t / 60))
  hor = fixDecimal(Math.floor(t / (60 * 60)))
  return "" + hor + ":" + min + ":" + sec

fixDecimal = (n) ->
  unless n >= 10
    return "0" + n
  return n

window.setInterval(callTimer, 1000)