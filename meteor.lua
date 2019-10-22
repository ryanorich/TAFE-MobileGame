local meteor = {}
local BASE_SIZE = 10

--Constructor
function meteor.new(target)
    local self = {}

    --Private Attributes
    self.size = BASE_SIZE
    self.FALL_SPEED = 500
    self.target = target
    self.targetx = target.x
    self.targety = target.y
    self.x =  love.math.random(self.size/2, love.graphics.getWidth()     -self.size/2)
    self.y = 0
    self.startx = self.x
    self.starty = self.y

    self.FALL_SPEED = 50

    function self:getXY()
        return self.x, self.y
    end

    function self:getX()
        return self.x 
    end

    function self:getY()
        return self.y  
    end

    function self:getStartXY()
        return self.startx, self.starty
    end

    function self:getTargetXY()
        return self.targety, self.targety
    end

    function self:update(dt)

        --Travel for Start to Target
        local distance = dt*self.FALL_SPEED
        local distanceToGo = math.pow((math.pow((self.x - self.target.x),2)

                                +math.pow((self.y - self.targety),2)), 0.5)

        if distance < distanceToGo then
            --Still have room to go
            local ratio = distance / distanceToGo
            self.x = self.x + (self.target.x - self.x)*ratio
            self.y = self.y + (self.targety - self.y)*ratio
        else
            --Reached the targetr
            self.x = target.x 
            self.y = target.y
            self.alive = false
        end
        
    end

    function self:draw()
        love.graphics.setColor(0.9, 0.1, 0.1, 1)
        love.graphics.line(self.startx, self.starty, self.x, self.y)
        love.graphics.setColor(0.9,0.4,0.2,1)
        love.graphics.circle("fill", self.x,  self.y, self.size)
    end


    return self
end

return meteor


