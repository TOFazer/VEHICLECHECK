fx_version 'cerulean'
game 'gta5'

name 'vehiclecheck'
author 'OVERX'
description 'Outils de diagnostic automobile pour serveurs FiveM RP'
version '0.1.0'

lua54 'yes'

shared_script 'shared/config.lua'
client_script 'client/main.lua'
server_script 'server/main.lua'

-- ESX n'est pas une dépendance obligatoire : la ressource valide le framework
-- au démarrage et affiche un avertissement explicite si nécessaire.
