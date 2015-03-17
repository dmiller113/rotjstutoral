class Glyph
  constructor: (symbol, foreground, background) ->
    @_char = symbol or ' '
    @_foreground = foreground || 'white'
    @_background - background || 'black'

  getChar: ->
    @_char

  getForeground: ->
    @_foreground

  getBackground: ->
    @_background

Game.Glyph = Glyph
