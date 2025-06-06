local love = require("love")
require("globals")

function Asteroid(x, y, astSize, level, sfx)
    local ASTEROID_VERT = 10
    local ASTEROID_JAG = 0.4
    local ASTEROID_SPEED = math.random(50) + (level * 2) + 9

    local vert = math.floor(math.random(ASTEROID_VERT + 1) + ASTEROID_VERT / 2)

    local offset = {}
    for i = 1, vert + 1 do
        table.insert(offset, math.random() * ASTEROID_JAG * 2 + 1 - ASTEROID_JAG)
    end

    local velocity = -1
    if math.random() < 0.5 then
        velocity = 1
    end

    return {
        x = x,
        y = y,
        xVelocity = math.random() * ASTEROID_SPEED * velocity,
        yVelocity = math.random() * ASTEROID_SPEED * velocity,
        radius = math.ceil(astSize / 2),
        angle = math.rad(math.random(math.pi)),
        vert = vert,
        offset = offset,

        draw = function(self, faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end

            love.graphics.setColor(186 / 255, 189 / 255, 182 / 255, opacity)
            local points = {
                self.x + self.radius * self.offset[1] * math.cos(self.angle),
                self.y + self.radius * self.offset[1] * math.sin(self.angle),
            }

            for i = 1, self.vert - 1 do
                table.insert(points,
                    self.x + self.radius * self.offset[i + 1] * math.cos(self.angle + i * math.pi * 2 / self.vert))
                table.insert(points,
                    self.y + self.radius * self.offset[i + 1] * math.sin(self.angle + i * math.pi * 2 / self.vert))
            end

            love.graphics.polygon("line", points)

            if showDebugging then
                love.graphics.setColor(1, 0, 0)
                love.graphics.circle("line", self.x, self.y, self.radius)
            end
        end,

        move = function(self, dt)
            self.x = self.x + self.xVelocity * dt
            self.y = self.y + self.yVelocity * dt

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
        end,

        destroy = function(self, asteroidsTbl, index, game)
            local MIN_ASTEROID_SIZE = math.ceil(ASTEROID_SIZE / 8)
            if self.radius > MIN_ASTEROID_SIZE then
                table.insert(asteroidsTbl, Asteroid(self.x, self.y, self.radius / 1.3, game.level, sfx))
                table.insert(asteroidsTbl, Asteroid(self.x, self.y, self.radius / 1.3, game.level, sfx))
            end
            if self.radius >= ASTEROID_SIZE / 2 then
                game.score = game.score + 20
            elseif self.radius <= MIN_ASTEROID_SIZE then
                game.score = game.score + 100
            else
                game.score = game.score + 50
            end

            if game.score > game.highscore then
                game.highscore = game.score
            end
            sfx:playSFX("asteroidExplosion")
            table.remove(asteroidsTbl, index)
        end
    }
end

return Asteroid
