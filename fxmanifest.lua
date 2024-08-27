fx_version 'cerulean'
game 'common'
lua54 'yes'

author 'Isekai'
description 'oxMySql overlay for easier database handling'
version '1.0.0'

server_script {
    '@oxmysql/lib/MySQL.lua',
    
    'oxCollector.lua',
}