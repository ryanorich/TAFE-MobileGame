local saucer = {}
local BASE_SIZE = 30

function saucer.new()
    local self = {}
    self.x  = 100
    self.y = 100
    self.size = BASE_SIZE

    function self:update(dt)
    end
    function self:draw()
        love.graphics.setColor(0.5, 0.5, 0.6)
        love.graphics.ellipse("fill", self.x, self.y, self.size/2, self.size/3)
    end

    return self
end

return saucer