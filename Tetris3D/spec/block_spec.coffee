window.describe "Block Class", ->
  block = null

  beforeEach ->
    block = new Tetris.Block(10)

  it "should be different from null", ->
    expect(block).not.toEqual(null)

  describe "Constructor default values", ->
    it "should have size 10", ->
      expect(block.size).toEqual(10)
    it "should not be moving", ->
      expect(block.moving).toBeFalsy()
    it "should have a cube shape", ->
      expect(block.cube).toBeDefined()
    it "should be in the center", ->
      expect(block.cube.position.x).toEqual(0)
      expect(block.cube.position.y).toEqual(0)
      expect(block.cube.position.z).toEqual(0)