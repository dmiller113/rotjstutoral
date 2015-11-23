Game.Screen = {}

# Screen interface is:
# enter: function(). Called when a screen is first swapped to.
# exit: function(). Called when a screen is swapped from.
# render: function(display). Called to render the screen onto the passed
#   display.
# handleInput(eventType, event): Called to handle various input events.

Game.Screen.startScreen =
  enter: ->
    console.log("we in dere")
  exit: ->
    console.log("we out of dere")
  render: (display) ->
    # Render the prompt to the screen
    display.drawText(1,1, "%c{yellow}Javascript Roguelike")
    display.drawText(1,2, "%c{gray}Press [Enter] to Start")
  handleInput: (eventType, event) ->
    # if [Enter] is pressed, go to the play screen
    if eventType == "keydown" and event.keyCode == ROT.VK_RETURN
      Game.switchScreen(Game.Screen.playScreen)

Game.Screen.playScreen =
  _map: null
  _centerX: 0
  _centerY: 0
  _mapWidth: 500,
  _mapHeight: 500,
  enter: ->
    console.log("Entered Play Screen")
    # Set up map. Empty map to begin with.
    map = [];
    # Ugly list comprehenions
    map.push(Game.Tile.nullTile for y in [0..(@_mapHeight - 1)]) for num in [0..(@_mapWidth - 1)]
    # Set up map generator from ROT
    generator = new ROT.Map.Cellular(@_mapWidth, @_mapWidth)
    generator.randomize(0.5)
    # We're going to smooth the automita 3 times.
    totalIterations = 3
    generator.create() for num in [1..totalIterations]
    # Last one, we're keeping the results
    generator.create((x, y, value) ->
      if value == 1
        map[x][y] = Game.Tile.wallTile
      else
        map[x][y] = Game.Tile.floorTile
    )
    @_map = new Game.Map(map)

  exit: ->
    console.log("Exited Play Screen")
  render: (display) ->
    # Figure out where our top left cell should be
    screenWidth = Game.getWidth()
    screenHeight = Game.getHeight()
    # Make sure the x-axis doesn't go to the left of the left bound
    topLeftX = Math.max(0, @_centerX - (screenWidth / 2));

    # Make sure we still have enough space to fit an entire game screen
    topLeftX = Math.min(topLeftX, @_map.getWidth() - screenWidth);

    # Make sure the y-axis doesn't above the top bound
    topLeftY = Math.max(0, @_centerY - (screenHeight / 2));

    # Make sure we still have enough space to fit an entire game screen
    topLeftY = Math.min(topLeftY, @_map.getHeight() - screenHeight);

    # Render the map to the display
    for x in [topLeftX..(topLeftX + screenWidth)]
      for y in [topLeftY..(topLeftY + screenHeight)]
        glyph = @_map.getTile(x,y).getGlyph()
        display.draw(x - topLeftX, y - topLeftY, glyph.getChar(),
          glyph.getForeground(), glyph.getBackground())
    # TEMP draw player
    display.draw(@_centerX - topLeftX, @_centerY - topLeftY, '@', 'white', 'black')

  move: (cx, cy) ->
    # X
    @_centerX = Math.max(0, Math.min(
      @_map.getWidth() - 1, (@_centerX + cx)
    ))

    # Y
    @_centerY = Math.max(0, Math.min(
      @_map.getHeight() - 1, (@_centerY + cy)
    ))

  handleInput: (eventType, event) ->
    if eventType == "keydown"
      switch event.keyCode
        when ROT.VK_RETURN
          Game.switchScreen(Game.Screen.winScreen)
        when ROT.VK_ESCAPE
          Game.switchScreen(Game.Screen.loseScreen)
        when ROT.VK_R
          Game.switchScreen(Game.Screen.playScreen)
        # Movement
        when ROT.VK_LEFT
          @move(-1, 0)
        when ROT.VK_RIGHT
          @move(1, 0)
        when ROT.VK_UP
            @move(0, -1);
        when ROT.VK_DOWN
            @move(0, 1);

Game.Screen.winScreen =
  enter: ->
    console.log("Entered winScreen")
  exit: ->
    console.log("Exiting winScreen")
  render: (display) ->
    display.drawText(1,1, "%c{green}Yay, you won.")
    display.drawText(1,2, "%c{gray}Press [Enter] to try again")
  handleInput: (eventType, event) ->
    if eventType == "keydown" and event.keyCode == ROT.VK_RETURN
      Game.switchScreen(Game.Screen.startScreen)

Game.Screen.loseScreen =
  enter: ->
    console.log("Entered loseScreen")
  exit: ->
    console.log("Exited loseScreen")
  render: (display) ->
    display.drawText(1,1, "%c{red}Buu, you lost.")
    display.drawText(1,2, "%c{gray}Press [Enter] to try again")
  handleInput: (eventType, event) ->
    if eventType == "keydown" and event.keyCode == ROT.VK_RETURN
      Game.switchScreen(Game.Screen.startScreen)
