local saucer = {}
local BASE_SIZE = 30
local BASE_SPEED = 200

function saucer.new()
    local self = {}
    self.size = BASE_SIZE
    self.speed = BASE_SPEED * math.random(0.7, 1.3)
    self.alive = true
    self.x  = 0-self.size
    self.y = math.random(0, love.graphics.getHeight()*0.6)
    
    function self:update(dt)
        self.x = self.x + self.speed*dt

        if self.x > love.graphics.getWidth() then
            self.alive = false
        end
    end

    function self:draw()
        love.graphics.setColor(0.5, 0.5, 0.6)
        love.graphics.ellipse("fill", self.x, self.y, self.size/2, self.size/3)
    end

    return self
end

return saucer