# constants
BLOCK_SIZE = 30
REFRESH_RATE = 120 # ms

# global variables
canvas = document.getElementById('game')

context = canvas.getContext "2d"
running = false
exploded = false
won = false
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

# draw the bomb image
drawBomb = (x, y) ->
  # the bomb circle
  context.beginPath()
  context.arc((x + 0.5) * BLOCK_SIZE, (y + 0.5) * BLOCK_SIZE, BLOCK_SIZE * 0.3, 0, 2 * Math.PI, false)
  context.fillStyle = "#000000"
  context.fill()
  context.moveTo((x + 0.5) * BLOCK_SIZE, (y + 0.05) * BLOCK_SIZE)
  context.lineTo((x + 0.5) * BLOCK_SIZE, (y + 0.95) * BLOCK_SIZE)
  context.moveTo((x + 0.05) * BLOCK_SIZE, (y + 0.5) * BLOCK_SIZE)
  context.lineTo((x + 0.95) * BLOCK_SIZE, (y + 0.5) * BLOCK_SIZE)
  context.moveTo((x + 0.16) * BLOCK_SIZE, (y + 0.16) * BLOCK_SIZE)
  context.lineTo((x + 0.83) * BLOCK_SIZE, (y + 0.83) * BLOCK_SIZE)
  context.moveTo((x + 0.83) * BLOCK_SIZE, (y + 0.16) * BLOCK_SIZE)
  context.lineTo((x + 0.16) * BLOCK_SIZE, (y + 0.83) * BLOCK_SIZE)
  context.lineWidth = 2
  context.strokeStyle = "#000000"
  context.stroke()
  # highlight on the top corner
  context.beginPath()
  context.arc((x + 0.35) * BLOCK_SIZE, (y + 0.35) * BLOCK_SIZE, BLOCK_SIZE * 0.1, 0, 2 * Math.PI, false)
  context.fillStyle = "#FFFFFF"
  context.fill()

drawWrong = (x, y) ->
  context.beginPath()
  context.moveTo(x * BLOCK_SIZE, y * BLOCK_SIZE)
  context.lineTo((x + 1) * BLOCK_SIZE, (y + 1) * BLOCK_SIZE)
  context.moveTo((x + 1) * BLOCK_SIZE, y * BLOCK_SIZE)
  context.lineTo(x * BLOCK_SIZE, (y + 1) * BLOCK_SIZE)
  context.lineWidth = 2
  context.strokeStyle = "#FF0000"
  context.stroke()

drawFlag = (x, y) ->
  context.beginPath()
  context.moveTo((x + 0.5) * BLOCK_SIZE, (y + 0.5) * BLOCK_SIZE)
  context.lineTo((x + 0.5) * BLOCK_SIZE, (y + 0.9) * BLOCK_SIZE)
  context.lineWidth = 2
  context.strokeStyle = "#000000"
  context.stroke()
  # drawing the triangle
  context.beginPath()
  context.moveTo((x + 0.55) * BLOCK_SIZE, (y + 0.1) * BLOCK_SIZE)
  context.lineTo((x + 0.55) * BLOCK_SIZE, (y + 0.55) * BLOCK_SIZE)
  context.lineTo((x + 0.1) * BLOCK_SIZE, (y + 0.3) * BLOCK_SIZE)
  context.closePath()
  context.fillStyle = "#FF0000"
  context.fill()
  #drawing flag base
  context.beginPath()
  context.moveTo((x + 0.4) * BLOCK_SIZE, (y + 0.7) * BLOCK_SIZE)
  context.lineTo((x + 0.6) * BLOCK_SIZE, (y + 0.7) * BLOCK_SIZE)
  context.lineTo((x + 0.6) * BLOCK_SIZE, (y + 0.8) * BLOCK_SIZE)
  context.lineTo((x + 0.4) * BLOCK_SIZE, (y + 0.8) * BLOCK_SIZE)
  context.closePath()
  context.fillStyle = "#000000"
  context.fill()
  context.beginPath()
  context.moveTo((x + 0.3) * BLOCK_SIZE, (y + 0.8) * BLOCK_SIZE)
  context.lineTo((x + 0.7) * BLOCK_SIZE, (y + 0.8) * BLOCK_SIZE)
  context.lineTo((x + 0.7) * BLOCK_SIZE, (y + 0.9) * BLOCK_SIZE)
  context.lineTo((x + 0.3) * BLOCK_SIZE, (y + 0.9) * BLOCK_SIZE)
  context.closePath()
  context.fillStyle = "#000000"
  context.fill()

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
    unless exploded or won
      flipPiece(mousePos.x, mousePos.y)
    return false
  false
)

canvas.addEventListener(
  'contextmenu'
  (evt) ->
    evt.preventDefault()
    mousePos = getMousePos(canvas, evt)
    unless exploded or won
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
  document.getElementById("message").innerHTML = "You just exploded!!!"
  bombsList.map (bomb) ->
    unless findItemInList(flagsList, bomb.x, bomb.y)
      drawDownButton(bomb.x, bomb.y)
      #drawCharacter(bomb.x, bomb.y, "B", "#000000")
      drawBomb(bomb.x, bomb.y)
  flagsList.map (flag) ->
    unless findItemInList(bombsList, flag.x, flag.y)
      drawUpButton(flag.x, flag.y)
      #drawCharacter(flag.x, flag.y, "W", "#0000FF")
      drawBomb(flag.x, flag.y)
      drawWrong(flag.x, flag.y)

# Recursively visits all neighbors to check if it s empty or not
discoverNeighbors = (x, y) ->
  tileNeighbors(x, y).map (tile) ->
    if 0 <= tile.x < levels[level].x and 0 <= tile.y < levels[level].y and !findItemInList(flagsList, tile.x, tile.y)
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
      #drawCharacter(x, y, "F", "#FF0000")
      drawFlag(x, y)
      bombs--
      if checkEndOfGame()
        won = true
        document.getElementById("message").innerHTML = "Congratulations!!! You WON!!!"
      updateBombs()

checkEndOfGame = ->
  if bombsList.length == flagsList.length
    flagsList.map (flag) ->
      unless findItemInList(bombsList, flag.x, flag.y)
        return false
    return true
  return false

# When the player chooses a new levels, sets up all the variables for a new game.
setNewLevel = (l) ->
  if l < levels.length
    level = l
    width = levels[level].x * BLOCK_SIZE
    height = levels[level].y * BLOCK_SIZE
    bombs = levels[level].bombs
    canvas.width = width
    canvas.height = height
    updateBombs()

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
  updateBombs()

#setInterval(callTimer, 1000)

###
  Controlling external elements
  - Level Select
  - Remaining Bombs #
  - Clock
###

# bombs number
updateBombs = ->
  #console.log("updateBombs: " + bombs)
  if bombs >= 0
    document.getElementById("bombs").innerHTML = bombs

# timer (clock)
callTimer = ->
  if running and !exploded and !won
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

levelForm = ""

# select new level
setFormListeners = ->
  levelForm = document.getElementById("levelBtn")
  levelForm.addEventListener("click", setNewLevelValue)

setNewLevelValue = ->
  levelSel = document.getElementById("levelSel")
  level = parseInt(levelSel.value)
  prepareCanvas()

prepareCanvas = ->
  document.getElementById("message").innerHTML = ""
  document.getElementById("time").innerHTML = convertNumToTimestamp(0)
  running = false
  exploded = false
  won = false
  time = 0
  bombs = levels[level].bombs
  bombsList = []
  flagsList = []
  flippedList = []
  setNewLevel(level)
  drawTable()
  setFormListeners()

prepareCanvas()