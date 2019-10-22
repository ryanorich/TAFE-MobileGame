local gun = {}

function gun.new(x, y)
    local self = {}

    self.x = x
    self.y = y
    self.alive = true
    local width = 80
    local gound = 50

    function self:draw()
        love.graphics.setColor(1.0,0.5,0.5,1)
        love.graphics.circle('fill', self.x, self.y + width/2, width*0.4)
        love.graphics.rectangle('fill', self.x-width/2, self.y+width*0.6, width, width)
    end

    return self
end

return gun