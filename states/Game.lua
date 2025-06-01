require("globals")
local love = require("love")
local Text = require("components.Text")
local Asteroid = require("objects.Asteroid")

function Game(saveData)
    gAsteroids = {}

    return {
        level = 1,
        state = {
            menu = true,
            paused = false,
            running = false,
            ended = false
        },
        score = 0,
        highscore = saveData.highScore or 0,
        screenText = {},
        gameOverShowing = false,

        saveGame = function(self)
            writeJSON("save", {
                highScore = self.highscore
            })
        end,

        changeGameState = function(self, state)
            self.state.menu = state == "menu"
            self.state.paused = state == "paused"
            self.state.running = state == "running"
            self.state.ended = state == "ended"

            if self.state.ended then
                self:gameOver()
            end
        end,

        gameOver = function(self)
            self.screenText = {
                Text("GAME OVER", 0, love.graphics.getHeight() * 0.4, "h1", true, true, love.graphics.getWidth(),
                    "center")
            }

            self.gameOverShowing = true

            self:saveGame()
        end,

        draw = function(self, faded)
            local opacity = 1

            if faded then
                opacity = 0.5
            end

            for index, text in pairs(self.screenText) do
                if self.gameOverShowing then
                    self.gameOverShowing = text:draw(self.screenText, index)

                    if not self.gameOverShowing then
                        self:changeGameState("menu")
                    end
                else
                    text:draw(self.screenText, index)
                end
            end

            Text("SCORE: " .. self.score, -20, 10, "h4", false, false, love.graphics.getWidth(), "right",
                faded and opacity or 0.6):draw()

            Text("HIGH SCORE: " .. self.highscore, 0, 10, "h5", false, false, love.graphics.getWidth(), "center",
                faded and opacity or 0.5):draw()

            if faded then
                Text("PAUSED", 0, love.graphics.getHeight() * 0.4, "h1", false, false, love.graphics.getWidth(), "center")
                    :draw()
            end
        end,

        startNewGame = function(self, player)
            if player.lives <= 0 then
                self:changeGameState("ended")
            else
                self:changeGameState("running")
            end

            local numAsteroids = 0

            self.screenText = {
                Text("Level " .. self.level, 0, love.graphics.getHeight() * 0.25, "h1", true, true,
                    love.graphics.getWidth(), "center")
            }

            for i = 1, numAsteroids + self.level do
                local asX, asY

                repeat
                    asX = math.floor(math.random(love.graphics.getWidth()))
                    asY = math.floor(math.random(love.graphics.getHeight()))
                until calculateDistance(player.x, player.y, asX, asY) > ASTEROID_SIZE * 2 + player.radius

                table.insert(gAsteroids, 1, Asteroid(asX, asY, ASTEROID_SIZE, self.level))
            end
        end
    }
end

return Game
