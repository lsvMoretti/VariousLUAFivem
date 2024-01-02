fx_version 'cerulean'
game 'gta5'

description 'Pacific Robbery for WintersRP'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    'shared/config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/*'
}

server_scripts {
    'server/*'
}

files {
    'html/*',
}

dependency 'PolyZone'

lua54 'yes'
use_fxv2_oal 'yes'