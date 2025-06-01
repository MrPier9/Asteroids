local love = require("love")
local Button = require("components.Button")

function Menu(game, player, sfx)
    local funcs = {
        newGame = function()
            game:startNewGame(player)
        end,
        quitGame = function()
            love.event.quit()
        end
    }

    local buttons = {
        -- Button(nil, { r = 0, g = 0, b = 0 }, { r = 1, g = 1, b = 1 }, love.graphics.getWidth() / 3, 50, "New Game", "center", "h3",
        Button(funcs.newGame, nil, nil, love.graphics.getWidth() / 3, 50, "New Game", "center", "h3",
            love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.25, nil, nil, "fill"),
        Button(nil, nil, nil, love.graphics.getWidth() / 3, 50, "Settings", "center", "h3",
            love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.4, nil, nil, "fill"),
        Button(funcs.quitGame, nil, nil, love.graphics.getWidth() / 3, 50, "Quit", "center", "h3",
            love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.55, nil, nil, "fill")
    }

    return {
        focused = "",
        run = function(self, clicked)
            local mouseX, mouseY = love.mouse.getPosition()
            for name, button in pairs(buttons) do
                if button:checkHover(mouseX, mouseY, cursorRadius) then
                    sfx:playSFX("optionSelect", "single")
                    if clicked then
                        button:onClick()
                    end

                    self.focused = name

                    button:setButtonColor(0.8, 0.2, 0.2)
                else
                    if self.focused == name then
                        sfx:setSFXPlayed(false)
                    end
                    button:setButtonColor(1, 1, 1)
                end
            end
        end,
        draw = function(self)
            for _, button in pairs(buttons) do
                button:draw()
            end
        end
    }
end

return Menu
