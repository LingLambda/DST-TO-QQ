name = "DST TO QQ"
description = [[
在QQ群中可以与游戏中聊天(基于xsluck大佬的项目),需要自己搭建koishi机器人,教程制作中
可在配置项启用特定消息转发,转发科雷id,开启日志
默认端口为http post 5140
]]
author = " ling , xsluck "
version = "0.0.3"
forumthread = ""
api_version = 10

dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true
all_clients_require_mod = false
client_only_mod = false

icon_atlas = 'icon.xml'
icon = "icon.tex"

configuration_options =
{
    {
        name = "isPrefix",
        label = "消息前缀",
        hover = "启用则前面带:的消息才会回传",
        options =
        {
            { description = "禁用", data = false },
            { description = "启用", data = true },
        },
        default = false,
    },
    {
        name = "isKleiId",
        label = "显示科雷id",
        hover = "启用则传到群里的消息会带上科雷id",
        options =
        {
            { description = "禁用", data = false },
            { description = "启用", data = true },
        },
        default = false,
    },
    {
        name = "isLog",
        label = "日志",
        hover = "打印日志便于排错",
        options =
        {
            { description = "禁用", data = false },
            { description = "启用", data = true },
        },
        default = false,
    },
    {
        name = "serverId",
        label = "服务器id",
        hover = "服务器id,用于多服务器操作,单服务器可无视",
        options  =
        {
            { description = "1", data = 1 },
            { description = "2", data = 2 },
            { description = "3", data = 3 },
            { description = "4", data = 4 },
            { description = "5", data = 5 },
            { description = "6", data = 6 },
            { description = "7", data = 7 },
            { description = "8", data = 8 },
            { description = "9", data = 9 },
        }
    }
}
