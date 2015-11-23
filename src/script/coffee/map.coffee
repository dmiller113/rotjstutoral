class Map
  constructor: (tiles) ->
    @_tiles = tiles
    # Grab our width and height from the passed array.
    @_width = tiles.length
    @_height = tiles[0].length
    console.log(@_width, @_height)
  # Getters
  getWidth: ->
    @_width
  getHeight: ->
    @_height
  # Get a specific tile
  getTile: (x, y) ->
    # Return null tile if x, y is out of bounds, otherwise return tile.
    if x >= 0 and x < @_width and y >= 0 and y < @_height
      @_tiles[x][y] || Game.Tile.nullTile
    else
      Game.Tile.nullTile

Game.Map = Map
