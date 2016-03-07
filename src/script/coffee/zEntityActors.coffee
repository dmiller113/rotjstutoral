Game.playerTemplate = {
  name: "Player",
  symbol: "@",
  foreground: "white",
  background: "black",
  atkValue: 10,
  maxHp: 40,
  itemSlots: 26,
  mixins: [Game.Mixins.Movable, Game.Mixins.PlayerActor,
    Game.Mixins.SimpleAttacker, Game.Mixins.MessageRecipient,
    Game.Mixins.SimpleDestructible, Game.Mixins.Inventory,
    Game.Mixins.PlayerPickup]
}

Game.fungusTemplate = {
  name: "Fungus",
  symbol: "F",
  foreground: "chartreuse",
  mixins: [Game.Mixins.FungusActor, Game.Mixins.FragileDestructible]
}
