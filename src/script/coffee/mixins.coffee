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
      if @hasMixin("Attacker")
        return @attack(target)
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

Game.Mixins.FragileDestructible =
  name: "FragileDestructible"
  groupName: "Destructible"
  init: () ->
    @_hp = 0

  takeDamage: (actor, damage) ->
    @_hp -= damage
    # If we have less than 0 hp than remove ourselves
    if @_hp < 0
      @getMap().removeEntity(@)

Game.Mixins.SimpleAttacker =
  name: "SimpleAttacker"
  groupName: "Attacker"
  attack: (target) ->
    if target.hasMixin("Destructible")
      target.takeDamage(@, 1)
      true
    else
      false
