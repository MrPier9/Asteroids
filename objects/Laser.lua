local love = require("love")

function Laser(x, y, angle)
    local LASER_SPEED = 500
    local EXPLOAD_DURATION = 0.2
    local exploadingEnum = {
        notExploading = 0,
        exploading = 1,
        doneExploading = 2
    }

    return {
        x = x,
        y = y,
        xVelocity = LASER_SPEED * math.cos(angle) / love.timer.getFPS(),
        yVelocity = -LASER_SPEED * math.sin(angle) / love.timer.getFPS(),
        distance = 0,
        isDestroyable = false,
        exploading = 0,
        exploadTime = 0,
        exploadingEnum = exploadingEnum,

        draw = function(self, faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end

            if self.exploading < exploadingEnum.exploading then
                love.graphics.setColor(1, 1, 1, opacity)
                love.graphics.setPointSize(3)
                love.graphics.points(self.x, self.y)
            else
                love.graphics.setColor(1, 104 / 255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, 7 * 1.5)
                love.graphics.setColor(1, 234 / 255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, 7 * 1)
            end
        end,

        move = function(self)
            self.x = self.x + self.xVelocity
            self.y = self.y + self.yVelocity

            if self.exploadTime > 0 then
                self.exploding = exploadingEnum.exploading
            end

            if self.x < 0 then
                self.isDestroyable = true
            end
            if self.x > love.graphics.getWidth() then
                self.isDestroyable = true
            end
            if self.y < 0 then
                self.isDestroyable = true
            end
            if self.y > love.graphics.getHeight() then
                self.isDestroyable = true
            end

            self.distance = self.distance + math.sqrt((self.x ^ 2) + (self.y ^ 2))
        end,

        expload = function(self)
            self.exploadTime = math.ceil(EXPLOAD_DURATION * (love.timer.getFPS() / 100))

            if self.exploadTime > EXPLOAD_DURATION then
                self.exploading = exploadingEnum.doneExploading
            end
        end
    }
end

return Laser
