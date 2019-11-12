local city = {
    scale = 1
}

local WIDTH = 64 
local GROUND = 32 

function city.new(x)
    local self = {}

    local scale = city.scale

    local width = WIDTH * scale
    local ground = GROUND * scale
    
    self.x = x
    self.y = love.graphics.getHeight() - ground
    
    local sprites = {
        city = love.graphics.newQuad(0,0,64,64,128,128),
        cityDead = love.graphics.newQuad(64,0,64,64,128,128)
    }
    
    self.alive = true

    function self:draw()
        love.graphics.setColor(1,1,1,1)
        if self.alive == true then
            --Normal Cities
            love.graphics.draw(spriteSheet, sprites["city"], self.x-width/2,self.y - width/2, 0, scale, scale )

        else
            --Destroyed Cities
            love.graphics.draw(spriteSheet, sprites["cityDead"], self.x-width/2, self.y - width/2, 0, scale, scale)
        end
    end

    self.sound = love.audio.newSource("sfx/building.wav","static")

    function self:playSound()
        if game.states.settings.soundOn then
            self.sound:play()
        end
    end
    return self
end

return city