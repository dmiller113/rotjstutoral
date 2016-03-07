Game.genericDataTemplate = {
  name: "Data",
  symbol: '=',
  foreground: "white",
  background: "black",
  useEffect: (target) ->
    if target.hasMixin("Destructible")
      target.takeDamage(@, 41)

  mixins: [Game.Mixins.WalkoverEffectItem]
}

Game.redDataTemplate = {
  name: "Offensive Data",
  symbol: '=',
  foreground: "red",
  background: "black",
  mixins: [Game.Mixins.WalkoverPickupItem]
}

Game.blueDataTemplate = {
  name: "Defensive Data",
  symbol: '=',
  foreground: "cyan",
  background: "black",
}

Game.greenDataTemplate = {
  # This is a terrible name
  name: "Utility Data",
  symbol: '=',
  foreground: "green",
  background: "black",
}
