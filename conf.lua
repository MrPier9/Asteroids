local love = require("love")

function love.conf(t)
    -- t.identity = "data/saves" -> allow us to assign a save file, the folder path/name is customizable
    -- t.version = "0.0.1"

    t.console = true -- for windows -> in case love attach a console to the drawinf window, if u dont want that console
    -- t.externalstorage = true -> if u want to save to another device

    --t.audio.mic = true

    t.window.title = "Asteroids"
    -- t.window.icon = "path" -> to custom the icon

    t.window.width = 1280
    t.window.height = 720
    -- t.window.width = 1920
    -- t.window.height = 1080
    
    -- t.window.resizable = true
    -- t.window.width = 1200
    -- t.window.height = 700
    -- t.window.borderless = true
    -- t.window.vsync = 1
    t.window.display = 2
    -- t.window.fullscreen = true

    --can also handle modules es.
    -- t.modules.timer = false

end