window.describe "Game class", ->
  game = null

  beforeEach ->
    game = new Game.Main(0, 0)

  it "should be different from null", ->
    expect(game).not.toEqual(null)

  describe "Constructor default values", ->
    it "should have width 0", ->
      expect(game.width).toEqual(0)
    it "should have height 0", ->
      expect(game.height).toEqual(0)
    it "should have a new stage", ->
      expect(game.stage).toBeDefined()
    it "should have the stage's width 0", ->
      expect(game.stage.getWidth()).toEqual(0)
    it "should have the stage's height 0", ->
      expect(game.stage.getHeight()).toEqual(0)
    it "should have layers", ->
      expect(game.layers).toBeDefined()

  describe "Creating the background", ->
    beforeEach ->
      game.createBackground()
    it "should have a game instance", ->
      expect(game).toBeDefined()
    it "should have a new layer", ->
      expect(game.layers.length).toBeGreaterThan(0)
    it "should have a rect defined inside the layer", ->
      expect(game.layers[game.layers.length - 1]).toBeDefined()

  describe "Creating Stars", ->
    beforeEach ->
      game.createStars(10)
    it "should create a new layer", ->
      expect(game.layers.length).toBeGreaterThan(0)
