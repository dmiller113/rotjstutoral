# Make the mixins namespace.
Game.Mixins = {}

# A movable entity. Technically this also allows digging, so fix later.
Game.Mixins.Movable = {
  name: "Movable",
  tryMove: (x, y, map) ->
    tile = map.getTile(x, y)

    if tile.isWalkable()
      @_x = x
      @_y = y
      return true
    else if tile.isDiggable()
      map.dig(x, y)
      return true
    else
      return false
}
