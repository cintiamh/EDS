# constants
BLOCK_SIZE = 30
REFRESH_RATE = 120 # ms

# global variables
canvas = document.getElementById('game') #$('#game').val()
context = canvas.getContext("2d")
running = false
explode = false
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
  unless running
    start()
    generateBombs(x, y)
  unless (findItemInList(flagsList, x, y))
    if (findItemInList(bombsList, x, y))
      # bomb explodes and game is over
      drawDownButton(x, y)
      drawCharacter(x, y, "B", "#000000")
    else
      discoverTiles(x, y)

discoverTiles = (x, y) ->
  unless findItemInList(flippedList, x, y)
    drawDownButton(x, y)
    count = countBombs(x, y)
    flippedList.push {x: x, y: y, v: count}
    if count == 0
      if y - 1 >= 0
        discoverTiles(x, y - 1)
      if y + 1 < levels[level].y
        discoverTiles(x, y + 1)
      if x - 1 >= 0
        discoverTiles(x - 1, y)
        if y - 1 >= 0
          discoverTiles(x - 1, y - 1)
        if y + 1 < levels[level].y
          discoverTiles(x - 1, y + 1)
      if x + 1 < levels[level].x
        discoverTiles(x + 1, y)
        if y - 1 >= 0
          discoverTiles(x + 1, y - 1)
        if y + 1 < levels[level].y
          discoverTiles(x + 1, y + 1)
    else
      drawCharacter(x, y, count, numColors[count - 1])


countBombs = (x, y) ->
  count = 0
  # count the number of neighbor bombs
  if x - 1 >= 0 and y - 1 >= 0
    if findItemInList(bombsList, x - 1, y - 1)
      count++
  if y - 1 >= 0
    if findItemInList(bombsList, x, y - 1)
      count++
  if x + 1 < levels[level].x and y - 1 >= 0
    if findItemInList(bombsList, x + 1, y - 1)
      count++
  if x - 1 >= 0
    if findItemInList(bombsList, x - 1, y)
      count++
  if x + 1 < levels[level].x
    if findItemInList(bombsList, x + 1, y)
      count++
  if x - 1 >= 0 and y + 1 < levels[level].y
    if findItemInList(bombsList, x - 1, y + 1)
      count++
  if y + 1 < levels[level].y
    if findItemInList(bombsList, x, y + 1)
      count++
  if x + 1 < levels[level].x and y + 1 < levels[level].y
    if findItemInList(bombsList, x + 1, y + 1)
      count++
  return count

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
    unless findItemInList(bombsList, newX, newY) or (newX == x and newY == y)
      bombsList.push({x: newX, y: newY})
      bombs++


putFlag = (x, y) ->
  unless findItemInList(flippedList, x, y)
    #if findFlagInList(x, y)
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

findItemInList = (list, x, y) ->
  for item in list
    if item.x == x and item.y == y
      return true
  return false

start = ->
  running = true
  flagsList = []

prepareCanvas = ->
  setNewLevel(0)
  drawTable()

prepareCanvas()
