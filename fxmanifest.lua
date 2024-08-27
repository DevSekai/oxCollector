fx_version 'cerulean'
game 'common'

lua54 'yes'
server_only 'yes'

author 'Isekai'
description 'oxMySql overlay for easier database handling'
version '1.0.1'

server_script {
    '@oxmysql/lib/MySQL.lua',
    
    'oxCollector.lua',
}