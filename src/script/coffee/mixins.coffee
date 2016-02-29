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

# Generic Destructable
Game.Mixins.SimpleDestructible =
  name: "SimpleDestructible"
  groupName: "Destructable"
  init: (template) ->
    # Defaults to 10hp, but takes it from the template
    @_maxHp = template['maxHp'] || 10
    # Defaults to full health, but can take it from the template
    @_hp = template['Hp'] || @_maxHp
    # Defaults to 0 def, but takes it from template
    @_defValue = template['defValue'] || 0

  getHp: () ->
    @_hp

  getMaxHp: () ->
    @_maxHp

  getDef: ->
    @_defValue

  takeDamage: (actor, damage) ->
    realDamage = Math.max(1, (damage - @_defValue))
    if @hasMixin("MessageRecipient")
      Game.sendMessage(@, Game.Messages.damageMessage,
        [actor.name, realDamage])

    @_hp -= realDamage
    # If we have less than 0 hp than remove ourselves
    if @_hp < 0
      if @hasMixin("MessageRecipient") and @hasMixin("PlayerActor")
        Game.sendMessage(@, Game.Messages.dieMessage)
      else if actor.hasMixin("MessageRecipient")
          Game.sendMessage(actor, Game.Messages.killMessage, [actor.name, @name])
      @getMap().removeEntity(@)

Game.Mixins.SimpleAttacker =
  name: "SimpleAttacker"
  groupName: "Attacker"
  init: (template) ->
    # Defaults to 1 attack, but takes it from the template
    @_atkValue = template['atkValue'] || 1

  getAttack: ->
    @_atkValue

  attack: (target) ->
    if target.hasMixin("Destructible")
      # Have a random chance to do from .5 to 1.5x the attack value.
      rDmg = Math.max(1, Math.floor((Math.random() + .5) * @_atkValue))
      target.takeDamage(@, rDmg)
      if @hasMixin("MessageRecipient")
        Game.sendMessage(@, Game.Messages.attackMessage,
          [@name, target.name, rDmg])
      true
    else
      false

Game.Mixins.MessageRecipient =
  name: "MessageRecipient"
  init: (template) ->
    @_messages = []

  getMessages: ->
    @_messages

  recieveMessage: (message) ->
    @_messages.push(message)

  clearMessage: () ->
    @_messages = []
