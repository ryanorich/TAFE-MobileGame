local city = {}


local WIDTH = 50
local GROUND = 20


function city.new(x)
    local self = {}

    local width = WIDTH
    local ground = GROUND
    

    self.x = x
    self.y = love.graphics.getHeight() - ground
    
    
    self.alive = true

    function self:draw()
        love.graphics.setColor(0.4,0.4,0.4,1)
        if self.alive == true then
            --Normal Cities
            love.graphics.rectangle('fill', self.x-width/2, self.y - width/2, width, width)
        else
            --Destroyed Cities
            love.graphics.rectangle('line', self.x-width/2, self.y - width/2, width, width)
    
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