---@diagnostic disable: lowercase-global
local lunajson = require("lunajson")

ASTEROID_SIZE = 100
showDebugging = false
destroyAst = false
cursorRadius = 10

function calculateDistance(x1, y1, x2, y2)
    return math.sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2)
end

function readJSON(fileName)
    local file = io.open("src/data/" .. fileName .. ".json", "r")
    if file == nil then return end
    local data = file:read("*all")
    file:close()

    return lunajson.decode(data)
end

function writeJSON(fileName, data)
    local file = io.open("src/data/" .. fileName .. ".json", "w")
    if file == nil then return end
    file:write(lunajson.encode(data))
    file:close()
end
