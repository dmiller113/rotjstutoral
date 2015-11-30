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

  getRandomFloorTile: () ->
    loop
      rX = Math.floor(ROT.RNG.getUniform() * @_width)
      rY = Math.floor(ROT.RNG.getUniform() * @_height)
      break if @getTile(rX, rY) == Game.Tile.floorTile
    {
      x: rX, y: rY,
    }

  dig: (x, y) ->
    # Check to see if we can dig the passed location
    tile = @getTile(x, y)
    if tile.isDiggable()
      @_tiles[x][y] = Game.Tile.floorTile

Game.Map = Map
