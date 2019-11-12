local gun = {
    scale = 1,
}

local GROUND = 32
local WIDTH = 64
local GUN_HEIGHT = 56

local GUN_COOLDOWN  = 1.2

local CD_WIDTH = 40
local CD_HEIGHT = 10
local CD_OFFSET = 16

function gun.new(x)
    local self = {}

    local scale = gun.scale
    local gunHeight = GUN_HEIGHT * scale
    local width = WIDTH * scale
    local ground = GROUND * scale

    self.x = x
    self.y = love.graphics.getHeight()-ground
    self.guny = love.graphics.getHeight() - gunHeight
    self.coolDown = GUN_COOLDOWN
    self.timer = 0

    self.alive = true

    local CDWidth = CD_WIDTH * scale
    local CDHeight = CD_HEIGHT * scale
    local CDOffset = CD_OFFSET * scale
    local CDX = self.x - CDWidth/2
    local CDY = self.y + CD_OFFSET - CDHeight/2
   
    local sprites = {
        gun = love.graphics.newQuad(0,64,64,64,128,128),
        gunDead = love.graphics.newQuad(64,64,64,64,128,128)
    }

    function self:draw()
        
        if self.alive == true then
            
            love.graphics.setColor(1,1,1,1)
            love.graphics.draw(spriteSheet, sprites["gun"], self.x-width/2, self.y - width/2, 0, gun.scale, gun.scale)
            love.graphics.setColor(0.1,0.3,0.1,1)
            love.graphics.rectangle('fill', CDX, CDY, CDWidth, CDHeight)
            if self.timer > 0 then
                love.graphics.setColor(0.9,0.2,0.2,1)
                love.graphics.rectangle('fill', CDX, CDY, CDWidth * self.timer/self.coolDown, CDHeight)
            end
        else
            love.graphics.setColor(1,1,1,1)
            love.graphics.draw(spriteSheet, sprites["gunDead"], self.x-width/2, self.y - width/2, 0, gun.scale, gun.scale)
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

    self.sound = love.audio.newSource("sfx/building.wav","static")

    function self:playSound()
        if game.states.settings.soundOn then
            self.sound:play()
        end
    end

    return self
end

return gun