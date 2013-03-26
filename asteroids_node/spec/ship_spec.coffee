window.describe "Ship class", ->
  ship = null

  beforeEach ->
    ship = new Game.Ship(0, 0)

  it "should be different from null", ->
    expect(ship).not.toEqual(null)

  describe "Constructor default values", ->
    it "should have max_speed 4", ->
      expect(ship.max_speed).toEqual(4)
    it "should have drag 0.01", ->
      expect(ship.drag).toEqual(0.01)
    it "should have a ship instance", ->
      expect(ship.ship).toBeDefined()
    it "should have zero velocity", ->
      expect(ship.velocity.x).toEqual(0)
      expect(ship.velocity.y).toEqual(0)
    it "should have zero acceleration", ->
      expect(ship.acceleration).toEqual(0)
    it "should be in position 0 0", ->
      expect(ship.x).toEqual(0)
      expect(ship.y).toEqual(0)

  describe "Set a new position", ->
    beforeEach ->
      ship.setPosition(3, 5)

    it "should have a new position 3, 5", ->
      expect(ship.x).toEqual(3)
      expect(ship.y).toEqual(5)

  describe "Set a new acceleration", ->
    beforeEach ->
      ship.setAcceleration(2)

    it "should have new acceleration equal to 2", ->
      expect(ship.acceleration).toEqual(2)

  describe "Get Hypotenuse value", ->
    it "the hypotenuse of 3 and 4 should be 5", ->
      hypotenuse = ship.getHypotenuse(3, 4)
      expect(hypotenuse).toEqual(5)



