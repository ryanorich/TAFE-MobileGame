local gun = {}

local GROUND = 50
local WIDTH = 50
local GUN_HEIGHT = 80
local GUN_COOLDOWN  = 1.0

local CD_WIDTH = 40
local CD_HEIGHT = 10

function gun.new(x)
    local self = {}

    local gunHeight = GUN_HEIGHT
    local width = WIDTH
    local gound = GROUND

    self.x = x
    self.y = love.graphics.getHeight()-GROUND
    self.guny = love.graphics.getHeight() - gunHeight
    self.coolDown = GUN_COOLDOWN
    self.timer = 0

    self.alive = true

    local CDX = self.x - CD_WIDTH/2
    local CDY = self.y - CD_HEIGHT/2
   

    function self:draw()
        

        if self.alive == true then
            love.graphics.setColor(0.3,0.3,0.4,1)
            love.graphics.circle('fill', self.x, self.guny +width/2 , width*0.4)
            love.graphics.rectangle('fill', self.x-width/2, self.y, width, width)

            love.graphics.setColor(0.1,0.3,0.1,1)
            love.graphics.rectangle('fill', CDX, CDY, CD_WIDTH, CD_HEIGHT)

            if self.timer > 0 then

                love.graphics.setColor(0.9,0.2,0.2,1)
                love.graphics.rectangle('fill', CDX, CDY, CD_WIDTH * self.timer/self.coolDown, CD_HEIGHT)
            end
        else
            love.graphics.setColor(0.3,0.3,0.4,1)
            love.graphics.circle('line', self.x, self.guny +width/2 , width*0.4)
            love.graphics.rectangle('line', self.x-width/2, self.y, width, width)
        end
    end

    function self:update(dt)
        if self.timer > 0 then
            self.timer = self.timer - dt
        end
    end

    function self:startCoolDown()
        self.timer = self.coolDown
    end

    return self
end

return gun