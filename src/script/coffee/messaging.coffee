Game.Messages = {}

Game.sendMessage = (recipient, message, args) ->
  if recipient.hasMixin("MessageRecipient")
    if typeof args != undefined
      message = vsprintf(message, args)
    recipient.recieveMessage(message)

# Attacker, Target, Damage
Game.Messages.attackMessage = "%s attacks the %s for %d damage!"

# Taking Damage
Game.Messages.damageMessage = "%s deals %d damage to you!"

# Killing otherEntities
Game.Messages.killMessage = "%s kills %s!"

# Dying
Game.Messages.dieMessage = "You die."
