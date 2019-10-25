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

    return self
end

return city