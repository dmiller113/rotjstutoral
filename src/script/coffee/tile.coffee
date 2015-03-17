class Tile
  constructor: (glyph) ->
    @_glyph = glyph

  getGlyph: ->
    @_glyph


Game.Tile = Tile

# Set some standard tiles
Game.Tile.nullTile = new Game.Tile(new Game.Glyph())
Game.Tile.wallTile = new Game.Tile(new Game.Glyph('#', 'goldenrod'))
Game.Tile.floorTile = new Game.Tile(new Game.Glyph('.'))
