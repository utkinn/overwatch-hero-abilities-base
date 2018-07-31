local networkStrings = {
    "allyChangedHero",
    "abilityCastRequest",
    "abilityCastSuccess",
    "openPermissionsMenu",
    "ultimateCastRequest",
    "adminConVarChanged",
    'OWA: Suicide',
}

for _, string in pairs(networkStrings) do
    util.AddNetworkString(string)
end
