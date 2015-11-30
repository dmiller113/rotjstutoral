class Entity extends Glyph
  constructor: (options) ->
    # House Keeping
    options = options || {}
    super(options)

    # Grab our properties
    @_name = options.name || ""
    @_x = options.x || 0
    @_y = options.y || 0

    # Handle Mixins
    @_attachedMixins = {}

    mixins = options.mixins || []

    for mixin in mixins
      # Add the mixin to the attached mixin object
      @_attachedMixins[mixin.name] = true

      # Add the properties of the mixin to this entity.
      for key, value of mixin when (key != "name" && key != "init" && !@hasOwnProperty(key))
        @[key] = value

      if "init" of mixin
        mixin.init.call(this, options)


  setName: (name) ->
    @_name = name || ''

  setX: (x) ->
    @_x = x || 0

  setY: (y) ->
    @_y = y || 0

  setXY: (x, y) ->
    if typeof x == "object"
      @setX(x.x)
      @setY(x.y)
    else
      @setX(x)
      @setY(y)

  getName: () ->
    @_name

  getX: () ->
    @_x

  getY: () ->
    @_y

  getXY: () ->
    {
      x: @_x,
      y: @_y,
    }

  # Can pass either the mixin itself or its name
  hasMixin: (obj) ->
    if typeof obj == "object"
      @_attachedMixins[obj.name] || false
    else if typeof obj == "string"
      @_attachedMixins[obj] || false
    else
      false


Game.playerTemplate = {
  name: "Player",
  symbol: "@",
  foreground: "white",
  background: "black",
  mixins: [Game.Mixins.Movable]
}
