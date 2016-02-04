# Make the mixins namespace.
Game.Mixins = {}

# A movable entity. Technically this also allows digging, so fix later.
Game.Mixins.Movable = {
  name: "Movable",
  groupName: "Movable",
  tryMove: (x, y, map) ->
    tile = map.getTile(x, y)
    target = map.getEntityAt(x, y)

    if target
      return false
    else if tile.isWalkable()
      @_x = x
      @_y = y
      return true
    else if tile.isDiggable()
      map.dig(x, y)
      return true
    else
      return false
}

Game.Mixins.PlayerActor = {
  name: "PlayerActor",
  groupName: "Actor",
  act: () ->
    Game.refresh()
    this.getMap().getEngine().lock()
}

Game.Mixins.FungusActor = {
  name: "FungusActor",
  groupName: "Actor",
  act: () ->
    true
}
