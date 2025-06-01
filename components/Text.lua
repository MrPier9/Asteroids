local love = require("love")

--[[
    PARAMETERS:
    ->text: string - text to be displayed (required)
    -> x: number - x position od text (required)
    -> y: number - y position of text (required)
    -> fontSize - string (optional)
        default: "p"
        options: "h1" - "h6", "p"
    -> fadeIn: boolean - should text fade in (optional)
        default: false
    -> fadeOut: boolean - Should text fade out (optional)
        default: false
    -> wrapWidth: number - whe should text break (optional)
        default: love.graphics.getWidth() [window width]
    -> align: string - align text to location (optional)
        default: "left"
    -> opacity: number (optional)
        dafault: 1
        options: 0.1 - 1
        NB: setting fadeIn = true will overwrite this to 0.1
]]
function Text(text, x, y, fontSize, fadeIn, fadeOut, wrapWidth, align, opacity)
    fontSize = fontSize or "p"
    fadeIn = fadeIn or false
    fadeOut = fadeOut or false
    wrapWidth = wrapWidth or love.graphics.getWidth()
    align = align or "left"
    opacity = opacity or 1

    local TEXT_FADE_DUR = 2

    local fonts = {
        h1 = love.graphics.newFont(60),
        h2 = love.graphics.newFont(50),
        h3 = love.graphics.newFont(40),
        h4 = love.graphics.newFont(30),
        h5 = love.graphics.newFont(20),
        h6 = love.graphics.newFont(10),
        p = love.graphics.newFont(16),
    }

    if fadeIn then
        opacity = 0.1
    end

    return {
        text = text,
        x = x,
        y = y,
        opacity = opacity,

        colors = {
            r = 1,
            g = 1,
            b = 1
        },

        setColor = function(self, red, green, blue)
            self.colors.r = red
            self.colors.g = green
            self.colors.b = blue
        end,

        draw = function(self, tblText, index)
            if self.opacity > 0 then
                if fadeIn then
                    if self.opacity < 1 then
                        self.opacity = self.opacity + (1 / TEXT_FADE_DUR / love.timer.getFPS())
                    else
                        fadeIn = false
                    end
                elseif fadeOut then
                    self.opacity = self.opacity - (1 / TEXT_FADE_DUR / love.timer.getFPS())
                end

                love.graphics.setColor(self.colors.r, self.colors.g, self.colors.b, self.opacity)
                love.graphics.setFont(fonts[fontSize])
                love.graphics.printf(self.text, self.x, self.y, wrapWidth, align)
                love.graphics.setFont(fonts["p"])
            else
                table.remove(tblText, index)
                return false
            end

            return true
        end
    }
end

return Text
