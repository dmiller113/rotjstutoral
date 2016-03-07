Game.Mixins.PlayerActor = {
  name: "PlayerActor",
  groupName: "Actor",
  act: () ->
    Game.refresh()
    @getMap().getEngine().lock()
    @clearMessage()
}

Game.Mixins.FungusActor = {
  name: "FungusActor",
  groupName: "Actor",
  init: () ->
    @_growthsRemaining = 5
  act: () ->
    growChance = Math.random()
    if @_growthsRemaining > 0 and growChance < 0.02
      xOffset = Math.floor(Math.random() * 3) - 1
      yOffset = Math.floor(Math.random() * 3) - 1
      xCoord = @getX() + xOffset
      yCoord = @getY() + yOffset

      if @getMap().isEmptyFloor(xCoord, yCoord)
        entity = new Entity(Game.fungusTemplate)
        entity.setXY(xCoord, yCoord)
        # Stop it from pooping all over my ram
        entity._growthsRemaining = @_growthsRemaining -= 1
        @getMap().addEntity(entity)
}
