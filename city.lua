local city = {}




function city.new(x, y)
    local self = {}

    self.x = x
    self.y = y
    
    local width = 80
    local ground = 50

    self.alive = true

    function self:draw()
        love.graphics.setColor(1.0,0.5,0.5,1)
        
        love.graphics.rectangle('fill', self.x-width/2, self.y+width*0.6, width, width)
    end

    return self
end

return city