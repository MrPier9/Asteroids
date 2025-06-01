local love = require("love")
local Laser = require("objects.Laser")
require("globals")

function Player(numLives)
    local SHIP_SIZE = 30
    local VIEW_ANGLE = math.rad(90)
    local MAX_NUM_LASERS = 10
    local EXPLOAD_DURATION = 3
    local USABLE_BLINKS = 5 * 2

    return {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        radius = SHIP_SIZE / 2,
        angle = VIEW_ANGLE,
        rotation = 0,
        exploadTime = 0,
        exploading = false,
        invincible = true,
        invincibleSeen = true,
        timeBlinked = USABLE_BLINKS,
        lasers = {},
        thrusting = false,
        thrust = {
            x = 0,
            y = 0,
            speed = 5,
            bigFlame = false,
            flame = 2.0
        },
        lives = numLives or 3,

        drawmFlameThrust = function(self, fillType, color)
            if self.invincibleSeen then
                table.insert(color, 0.5)
            end
            love.graphics.setColor(color)
            love.graphics.polygon(
                fillType,
                self.x - self.radius * (2 / 3 * math.cos(self.angle) + 0.5 * math.sin(self.angle)),
                self.y + self.radius * (2 / 3 * math.sin(self.angle) - 0.5 * math.cos(self.angle)),
                self.x - self.radius * self.thrust.flame * math.cos(self.angle),
                self.y + self.radius * self.thrust.flame * math.sin(self.angle),
                self.x - self.radius * (2 / 3 * math.cos(self.angle) - 0.5 * math.sin(self.angle)),
                self.y + self.radius * (2 / 3 * math.sin(self.angle) + 0.5 * math.cos(self.angle))
            )
        end,

        shootLaser = function(self)
            if #self.lasers <= MAX_NUM_LASERS then
                table.insert(self.lasers, Laser(self.x, self.y, self.angle))
            end
        end,

        destroyLaser = function(self, index)
            table.remove(self.lasers, index)
        end,

        draw = function(self, faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end

            if not self.exploading then
                if self.thrusting then
                    if not self.thrust.bigFlame then
                        self.thrust.flame = self.thrust.flame - 1 / love.timer.getFPS()

                        if self.thrust.flame < 1.5 then
                            self.thrust.bigFlame = true
                        end
                    else
                        self.thrust.flame = self.thrust.flame + 1 / love.timer.getFPS()

                        if self.thrust.flame > 2.5 then
                            self.thrust.bigFlame = false
                        end
                    end

                    self:drawmFlameThrust("fill", { 255 / 255, 102 / 255, 25 / 255 })
                    self:drawmFlameThrust("line", { 1, 0.16, 0 })
                end
                if showDebugging then
                    love.graphics.setColor(1, 0, 0)

                    love.graphics.rectangle("fill", self.x - 1, self.y - 1, 2, 2)

                    love.graphics.circle("line", self.x, self.y, self.radius)
                end

                if self.invincibleSeen then
                    love.graphics.setColor(1, 1, 1, faded and opacity or 0.5)
                else
                    love.graphics.setColor(1, 1, 1, opacity)
                end

                love.graphics.polygon(
                    "line",
                    self.x + ((4 / 3) * self.radius) * math.cos(self.angle),
                    self.y - ((4 / 3) * self.radius) * math.sin(self.angle),
                    self.x - self.radius * (2 / 3 * math.cos(self.angle) + math.sin(self.angle)),
                    self.y + self.radius * (2 / 3 * math.sin(self.angle) - math.cos(self.angle)),
                    self.x - self.radius * (2 / 3 * math.cos(self.angle) - math.sin(self.angle)),
                    self.y + self.radius * (2 / 3 * math.sin(self.angle) + math.cos(self.angle))
                )

                for _, laser in pairs(self.lasers) do
                    laser:draw(faded)
                end
            else
                love.graphics.setColor(1, 0, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, self.radius * 1.5)
                love.graphics.setColor(1, 158 / 255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, self.radius * 1)
                love.graphics.setColor(1, 234 / 255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, self.radius * 0.5)
            end
        end,

        drawLives = function(self, faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end

            if self.lives == 2 then
                love.graphics.setColor(1, 1, 0.5, opacity)
            elseif self.lives == 1 then
                love.graphics.setColor(1, 0.2, 0.2, opacity)
            else
                love.graphics.setColor(1, 1, 1, opacity)
            end

            local xLives, yLives = 45, 30

            for i = 1, self.lives do
                if self.exploading then
                    if i == self.lives then
                        love.graphics.setColor(1, 0, 0, opacity)
                    end
                end

                love.graphics.polygon(
                    "line",
                    (i * xLives) + ((4 / 3) * self.radius) * math.cos(VIEW_ANGLE),
                    yLives - ((4 / 3) * self.radius) * math.sin(VIEW_ANGLE),
                    (i * xLives) - self.radius * (2 / 3 * math.cos(VIEW_ANGLE) + math.sin(VIEW_ANGLE)),
                    yLives + self.radius * (2 / 3 * math.sin(VIEW_ANGLE) - math.cos(VIEW_ANGLE)),
                    (i * xLives) - self.radius * (2 / 3 * math.cos(VIEW_ANGLE) - math.sin(VIEW_ANGLE)),
                    yLives + self.radius * (2 / 3 * math.sin(VIEW_ANGLE) + math.cos(VIEW_ANGLE))
                )
            end
        end,

        move = function(self, dt)
            if self.invincible then
                self.timeBlinked = self.timeBlinked - dt * 2

                if math.ceil(self.timeBlinked) % 2 == 0 then
                    self.invincibleSeen = false
                else
                    self.invincibleSeen = true
                end

                if self.timeBlinked <= 0 then
                    self.invincible = false
                end
            else
                self.timeBlinked = USABLE_BLINKS
                self.invincibleSeen = false
            end
            self.exploading = self.exploadTime > 0

            if not self.exploading then
                local FPS = love.timer.getFPS()
                local friction = 0.7

                self.rotation = 360 / 180 * math.pi / FPS

                if love.keyboard.isDown("a") or love.keyboard.isDown("left") or love.keyboard.isDown("kp4") then
                    self.angle = self.angle + self.rotation
                end

                if love.keyboard.isDown("d") or love.keyboard.isDown("right") or love.keyboard.isDown("kp6") then
                    self.angle = self.angle - self.rotation
                end

                if self.thrusting then
                    self.thrust.x = self.thrust.x + self.thrust.speed * math.cos(self.angle) / FPS
                    self.thrust.y = self.thrust.y - self.thrust.speed * math.sin(self.angle) / FPS
                else
                    if self.thrust.x ~= 0 or self.thrust.y ~= 0 then
                        self.thrust.x = self.thrust.x - friction * self.thrust.x / FPS
                        self.thrust.y = self.thrust.y - friction * self.thrust.y / FPS
                    end
                end

                self.x = self.x + self.thrust.x
                self.y = self.y + self.thrust.y

                if self.x + self.radius < 0 then
                    self.x = love.graphics.getWidth() + self.radius
                end
                if self.x - self.radius > love.graphics.getWidth() then
                    self.x = 0 - self.radius
                end
                if self.y + self.radius < 0 then
                    self.y = love.graphics.getHeight() + self.radius
                end
                if self.y - self.radius > love.graphics.getHeight() then
                    self.y = 0 - self.radius
                end
            end

            for index, laser in pairs(self.lasers) do
                if laser.isDestroyable and laser.exploading == laser.exploadingEnum.notExploading then
                    laser:expload()
                end

                if laser.exploading == laser.exploadingEnum.notExploading then
                    laser:move()
                elseif laser.exploading == laser.exploadingEnum.doneExploading then
                    self.destroyLaser(self, index)
                end
            end
        end,

        expload = function(self)
            self.exploadTime = math.ceil(EXPLOAD_DURATION * love.timer.getFPS())
        end
    }
end

return Player
