local missile  = {}
local BASE_SPEED = 300

function missile.new(source, tx, ty)
    local self = {}

    self.source = source
    self.x = source.x
    self.y = source.guny
    
    self.targetx = tx
    self.targety = ty
    self.alive = true

    self.sound = love.audio.newSource("sfx/missile.wav","static")
    --Misile sound plays when created
    if game.states.settings.soundOn  then

        self.sound:play()
    end

    local distance = 0

    local totalDistance = math.pow(math.pow((source.x - self.targetx), 2) + 
                                  math.pow((source.y - self.targety), 2) , 0.5)

    self.speed = BASE_SPEED

    function self:update(dt)
        
        distance = distance + self.speed*dt

        if distance >= totalDistance then
            self.x = self.targetx
            self.y = self.targety
            self.alive = false
        else
            local distanceRatio  = distance / totalDistance
            self.x = self.source.x + (self.targetx - self.source.x)*distanceRatio
            self.y = self.source.guny + (self.targety - self.source.y)*distanceRatio
        end
    end
    
    function self:draw()
        love.graphics.setColor(0.5,1.0,0.2,1.0)
        love.graphics.line(self.source.x, self.source.guny, self.x, self.y)
        love.graphics.circle('fill', self.x, self.y, 5)
    end

    return self
end

return missile