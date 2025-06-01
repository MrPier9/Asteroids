local love = require("love")
local Text = require("components.Text")

function Button(func, textColor, buttonColor, width, height, text, textAlign, fontSize, buttonX, buttonY, textX, textY,
                fillType)
    local btnText = {
        x = buttonX,
        y = buttonY,
    }
    func = func or function() print("This button has no function attached") end

    -- print(func, textColor, buttonColor, width, height, text, textAlign, fontSize, buttonX, buttonY, textX, textY,
    --     fillType)

    -- print("text - " .. textColor['r'], textColor['g'],textColor['b'])
    -- print("button - " .. buttonColor['r'], buttonColor['g'],buttonColor['b'])

    if textX then
        btnText.x = textX + buttonX
    end
    if textY then
        btnText.y = textY + buttonY
    end

    return {
        textColor = textColor or { r = 0, g = 0, b = 0 },
        buttonColor = buttonColor or { r = 1, g = 1, b = 1 },
        width = width or 100,
        height = height or 100,
        text = text or "",
        textX = textX or buttonX or 0,
        textY = textY or buttonY or 0,
        buttonX = buttonX or 0,
        buttonY = buttonY or 0,
        textComponent = Text(text, btnText.x, btnText.y, fontSize, false, false, width, textAlign, 1),
        fillType = fillType,

        setButtonColor = function(self, red, green, blue)
            self.buttonColor = { r = red, g = green, b = blue }
        end,

        setButtonTextColor = function(self, red, green, blue)
            self.buttonColor = { r = red, g = green, b = blue }
        end,

        checkHover = function (self, mouseX, mouseY, cursorRadius)
            if (mouseX + cursorRadius > self.buttonX) and (mouseX - cursorRadius <= self.buttonX + self.width)
                and (mouseY + cursorRadius > self.buttonY) and (mouseY - cursorRadius <= self.buttonY + self.height) then
                return true
            end
            return false
        end,

        onClick = function(self)
            func()
        end,

        draw = function(self)
            love.graphics.setColor(self.buttonColor['r'], self.buttonColor['g'], self.buttonColor['b'], 1)
            love.graphics.rectangle(fillType, self.buttonX, self.buttonY, self.width, self.height)

            self.textComponent:setColor(self.textColor['r'], self.textColor['g'], self.textColor['b'], 1)
            self.textComponent:draw()

            love.graphics.setColor(1, 1, 1)
        end,

        getButtonPosition = function(self)
            return self.buttonX, self.buttonY
        end,

        getButtonTextPosition = function(self)
            return self.textX, self.textY
        end,
    }
end

return Button
