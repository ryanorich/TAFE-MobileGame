local blast = {}

BASE_SIZE = 100
BLAST_TIME = 0.5
SHRINK_TIME = 0.3

function blast.sizeIncrease(increase)
    BASE_SIZE = BASE_SIZE * increase
end

function blast.new(x, y)
    local self = {}

    self.x = x
    self.y = y
    local size = 1
    local growing = true
    self.alive = true

    local MAX_SIZE = BASE_SIZE
    local GROW_SPEED = MAX_SIZE/BLAST_TIME
    local SHRINK_SPEED = MAX_SIZE/SHRINK_TIME
    
    
    function self:hasDestroyed(target)
        --Required distance between cencres
        distance  = (target.size + size) /2

        --Quick check for X-position
        local dx = math.abs(target.x - self.x)
        if dx > distance then
            return false
        end
        
        --Quick check for y position
        local dy = math.abs(target.y - self.y)
        if dy > distance then
            return false
        end

        --final check for actual distance
        dxy = math.pow((math.pow(dx, 2)+ math.pow(dy,2)),0.5)
        if dxy > distance then 
            return false 
        else 
            return true 
        end

    end


    --Updat the blast size, and state form growing to shrinking.
    function self:update(dt)
        if growing then
            size = size + GROW_SPEED * dt
            if size >= MAX_SIZE then
                growing = false
            end
        else
            size = size - SHRINK_SPEED * dt
            if size <= 0 then
                size = 0
                alive = false
            end
        end
    end

    function self:draw()
        love.graphics.setColor(0,love.math.random(0.7, 1.0),love.math.random(0,0.4),1)
        love.graphics.circle("fill", self.x, self.y, size)
    end



    return self
end



return blast