fx_version "bodacious"
game "gta5"
lua54 "yes"

author "flexiboi"
description "Flex-portableworkbench"
version "1.0.0"

ui_page 'html/index.html'

shared_scripts {
    'config.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
}

server_scripts {
    'server/main.lua',
}

client_scripts {
	'client/main.lua',
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/CircleZone.lua',
}

files {
	'html/*',
	'ch_prop_nmc_furnance.ytyp',
    'ch_prop_nmc_furnance.ydr',
    'shell_warehouse3.ydr',
	'shellpropsv5.ytyp',
}

data_file 'DLC_ITYP_REQUEST' 'ch_prop_nmc_furnance.ytyp'
data_file 'DLC_ITYP_REQUEST' 'ch_prop_nmc_furnance.ydr'
data_file 'DLC_ITYP_REQUEST' 'shell_warehouse3.ydr'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv5.ytyp'

dependencies {
	'qb-core'
}