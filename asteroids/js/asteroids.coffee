WIDTH = window.innerWidth
HEIGHT = window.innerHeight

stars = []

stage = new Kinetic.Stage
  container: 'container'
  width: WIDTH
  height: HEIGHT

# Creating the stars on the background
starsLayer = new Kinetic.Layer

createStars = (num) ->
  for n in [0..num]
    stars.push(new Kinetic.Star(
      x: Math.random() * WIDTH
      y: Math.random() * HEIGHT
      numPoints: 5
      innerRadius: Math.random() * 1 + 0.5
      outerRadius: Math.random() * 2 + 1.5
      fill: '#CCFFFF'
    ))
    starsLayer.add(stars[n])

createStars(200)
stage.add(starsLayer)

