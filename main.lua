---@diagnostic disable: lowercase-global
package.path = package.path .. ";C:\\Users\\mrpie\\AppData\\Roaming\\luarocks\\share\\lua\\5.4\\?.lua;;"
local love = require("love")
local Player = require("objects.Player")
local Game = require("states.Game")
local Menu = require("states.Menu")
local SFX = require("components.SFX")

local resetComplete = false

math.randomseed(os.time())

function reset()
    local saveData = readJSON("save")
    sfx = SFX()
    player = Player(3, sfx)
    game = Game(saveData, sfx)
    menu = Menu(game, player, sfx)
    destroyAst = false
end

function love.load()
    love.mouse.setVisible(false)

    mouseX, mouseY = 0, 0

    reset()

    sfx:playBGM()
end

function love.keypressed(key)
    if game.state.running then
        if key == "w" or key == "up" or key == "kp8" then
            player.thrusting = true
        end

        if key == "space" or key == "down" or key == "kp5" then
            player:shootLaser()
        end

        if key == "escape" then
            game:changeGameState("paused")
        end
    elseif game.state.paused then
        if key == "escape" then
            game:changeGameState("running")
        end
    end
end

function love.keyreleased(key)
    if key == "w" or key == "up" or key == "kp8" then
        player.thrusting = false
    end
end

function love.mousepressed(x, y, button, istouch, pressed)
    if button == 1 then
        if game.state.running then
            player:shootLaser()
        else
            clickedMouse = true
        end
    end
end

function love.update(dt)
    mouseX, mouseY = love.mouse.getPosition()
    if game.state.running then
        player:move(dt)
        for astIndex, asteroid in pairs(gAsteroids) do
            if not player.exploading and not player.invincible then
                if calculateDistance(player.x, player.y, asteroid.x, asteroid.y) < asteroid.radius then
                    player:expload()
                    destroyAst = true
                end
            else
                sfx:playSFX("shipExplosion", "single")
                player.exploadTime = player.exploadTime - 1

                if player.exploadTime == 0 then
                    if player.lives - 1 <= 0 then
                        game:changeGameState("ended")
                        return
                    end

                    player = Player(player.lives - 1, sfx)
                end
            end

            for _, laser in pairs(player.lasers) do
                if calculateDistance(laser.x, laser.y, asteroid.x, asteroid.y) < asteroid.radius then
                    laser:expload()
                    asteroid:destroy(gAsteroids, astIndex, game)
                end
            end

            if destroyAst then
                if player.lives - 1 <= 0 then
                    if player.exploadTime == 0 then
                        destroyAst = false
                        asteroid:destroy(gAsteroids, astIndex, game)
                    end
                else
                    destroyAst = false
                    asteroid:destroy(gAsteroids, astIndex, game)
                end
            end

            asteroid:move(dt)
        end
        if #gAsteroids == 0 then
            game.level = game.level + 1
            game:startNewGame(player)
        end
    elseif game.state.menu then
        menu:run(clickedMouse)

        clickedMouse = false

        if not resetComplete then
            reset()
            resetComplete = true
        end
    elseif game.state.ended then
        resetComplete = false
    end
end

function love.draw()
    if game.state.running or game.state.paused then
        player:drawLives(game.state.paused)
        player:draw(game.state.paused)

        for _, asteroid in pairs(gAsteroids) do
            asteroid:draw(game.state.paused)
        end

        game:draw(game.state.paused)
    elseif game.state.menu then
        menu:draw()
    elseif game.state.ended then
        game:draw()
    end

    love.graphics.setColor(1, 1, 1, 1)

    if not game.state.running then
        love.graphics.circle("fill", mouseX, mouseY, cursorRadius)
    end

    love.graphics.print(love.timer.getFPS())
end

--101158
