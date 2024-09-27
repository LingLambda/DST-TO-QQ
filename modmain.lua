local _G = GLOBAL
local jsonUtil = require "json"

-- 打印日志
local function printLog(log)
    if GetModConfigData("isLog") then
        print(log)
    end
end

-- 相关配置
IS_PREFIX = GetModConfigData("isPrefix")
SERVER_ID = GetModConfigData("serverId")
HOST = 'http://127.0.0.1:5140'

-- 服务相关URL
AddPrefabPostInit("world", function(inst)
    local OldNetworking_Say = GLOBAL.Networking_Say
    GLOBAL.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote, user_vanity)
        local r = OldNetworking_Say(guid, userid, name, prefab, message, colour, whisper, isemote, user_vanity)
        if GLOBAL.TheNet and GLOBAL.TheNet:GetIsServer() and inst.ismastershard then
            if IS_PREFIX then
                if string.lower(string.sub(message, 1, 1)) == ":" or string.lower(string.sub(message, 1, 1)) == "：" then
                    message = string.sub(message, 2)
                    sendGroupMsg(guid, userid, name, prefab, message, colour, whisper, isemote, user_vanity)
                end
            else
                sendGroupMsg(guid, userid, name, prefab, message, colour, whisper, isemote, user_vanity)
            end
        end
        return r
    end
end)

-- 发送群组消息
sendGroupMsg = function(guid, userid, name, prefab, message, colour, whisper, isemote)
    printLog(guid .. userid .. name .. prefab .. message)
    if whisper then
        return
    end
    local userIdStr = userid
    if GLOBAL.ThePlayer ~= nil then
        userIdStr = GLOBAL.ThePlayer.userid
    end
    local toGroupJson = {userName = name , survivorsName = prefab, message = message, serverId = SERVER_ID ,kleiId = userIdStr }
    printLog('将要发送到群聊:' .. jsonUtil.encode(toGroupJson))
    GLOBAL.TheSim:QueryServer(HOST .. '/send_msg', onSendGroupMsgResult, "POST", jsonUtil.encode(toGroupJson))
end

-- 获取群消息
AddSimPostInit(function(inst)
    if GLOBAL.TheNet and GLOBAL.TheNet:GetIsServer() then
        GLOBAL.TheWorld:DoPeriodicTask(4, function(inst)
            if inst.ismastershard then
                local toGroupJson = { serverId = SERVER_ID }
                GLOBAL.TheSim:QueryServer(HOST .. '/get_msg', onGetGroupMsgResult, "POST", jsonUtil.encode(toGroupJson))
            end
        end)
    end
end)

-- 解析发送群组消息结果
function onSendGroupMsgResult(result, isSuccessful, resultCode)
    if resultCode == 200 then
        printLog("发送消息到群组成功")
    else
        printLog("发送消息到群组失败:" .. jsonUtil.encode(result))
    end
end

-- 解析获取群组消息结果
function onGetGroupMsgResult(result, isSuccessful, resultCode)
    if resultCode == 200 and result then
        printLog("获取消息成功:" .. result)
        local messages = jsonUtil.decode(result).messages
        if #messages == 0 then
            printLog("暂无新消息")
            return
        end
        for _, value in ipairs(messages) do
            if value[4] then
                printLog('收到命令:' .. value[1])
                runCommand(value)
            else
                printLog('收到群消息' .. value[1] .. '：' .. value[2])
                GLOBAL.TheNet:SystemMessage(value[1] .. '：' .. value[2])
            end
        end
    else
        printLog("获取消息失败:" .. jsonUtil.encode(result))
    end
end

-- 运行命令
function runCommand(value)
    if value[1] == "rollback" then
        _G.ExecuteConsoleCommand("c_rollback(" .. value[2] .. ")")
    elseif value[1] == 'reset' then
        _G.ExecuteConsoleCommand("c_regenerateworld()")
    elseif value[1] == 'save' then
        _G.ExecuteConsoleCommand("c_save()")
    elseif value[1] == 'ban' then
        _G.ExecuteConsoleCommand("TheNet:Kick(" .. value[2] .. ") ")
        _G.ExecuteConsoleCommand("TheNet:Ban(" .. value[2] .. ") ")
    end
end
