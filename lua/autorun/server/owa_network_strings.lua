local networkStrings = {
    "allyChangedHero",
    "abilityCastRequest",
    "abilityCastSuccess",
    "openPermissionsMenu",
    "ultimateCastRequest",
    "adminConVarChanged",
    'OWA: Suicide',
    'OWA: Hero select menu entered/exited'
}

for _, string in pairs(networkStrings) do
    util.AddNetworkString(string)
end
