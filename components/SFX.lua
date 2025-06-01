local love = require("love")

function SFX()
    local bgm = love.audio.newSource("src/sounds/bgm.mp3", "stream")
    bgm:setVolume(0.1)
    bgm:setLooping(true)

    local effects = {
        shipExplosion = love.audio.newSource("src/sounds/explosion_player.ogg", "static"),
        asteroidExplosion = love.audio.newSource("src/sounds/explosion_asteroid.ogg", "static"),
        laser = love.audio.newSource("src/sounds/laser.ogg", "static"),
        optionSelect = love.audio.newSource("src/sounds/option_select.ogg", "static"),
        thruster = love.audio.newSource("src/sounds/thruster_loud.ogg", "static"),
    }

    return {
        fxPlayed = false,

        setSFXPlayed = function(self, hasPlayed)
            self.fxPlayed = hasPlayed
        end,

        playBGM = function(self)
            if not bgm:isPlaying() then
                bgm:play()
            end
        end,

        stopSFX = function(self, effect)
            if effects[effect]:isPlaying() then
                effects[effect]:stop()
            end
        end,

        playSFX = function(self, effect, mode)
            if mode == "single" then
                if not self.fxPlayed then
                    self:setSFXPlayed(true)
                    if not effects[effect]:isPlaying() then
                        effects[effect]:play()
                    end
                end
            elseif mode == "slow" then
                if not effects[effect]:isPlaying() then
                    effects[effect]:play()
                end
            else
                self:stopSFX(effect)
                effects[effect]:play()
            end
        end
    }
end

return SFX
