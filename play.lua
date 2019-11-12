local Meteor = require( 'meteor')
local Gun = require ('gun')
local Missile = require ('missile')
local City = require ('city')
local Blast = require ('blast')
local Button = require ('button')
local Saucer = require ('saucer')

--Local parameters for play
local play = 
{
    --Object form Exgternal Classes
    blasts = {},
    cities = {},
    guns = {},
    meteors = {},
    missiles = {},
    saucers = {},

    time = 0,

    GROUND_HEIGHT = 32,
    GUN_X_OFFSET = 50,
    GUN_CITY_SPACING = 0, --Need to calculate
 
    paused = false,
    pauseButtons = {},

    font = love.graphics.newFont(love.graphics.getWidth()*0.025),
    textColor = {0.5,0.9,0.4,1.0},
    
    sprites = {
        city = love.graphics.newQuad(0,0,64,64,128,128),
        cityDead = love.graphics.newQuad(64,0,64,64,128,128),
        gun = love.graphics.newQuad(0,64,64,64,128,128),
        gunDead = love.graphics.newQuad(64,64,64,64,128,128),
    },
}

--Returns the current time value.
function play:getTime()
    return self.time
end

function play:getTimeScore()
    return tonumber(string.format("%.3f", self.time))
end

--Startup
function play:entered()
    
    self.paused = false
    self.pauseButtons = {}

    --Create Global spritesheet object
    spriteSheet = love.graphics.newImage("gfx/sprites.png")

    --Stop the music from playing
    game.states.menu.BGMusic:stop()

    local ww, wh = love.graphics.getDimensions()

    local noOfButtons = 2
    local buttonWidth = ww * 0.4
    local buttonHeight = wh * 0.1
    local buttonSpacing = buttonHeight * 0.4
    local totalButtonHeight = noOfButtons * (buttonHeight + buttonSpacing) - buttonSpacing
    local bx = (ww - buttonWidth) * 0.5
    local by = (wh - totalButtonHeight) * 0.5

    --Button 1 - Continue
    Button.setColors( {0.4, 0.5, 0.3, 1.0}, {0.8, 0.9, 0.5, 1.0}, {0,0.2,0,1.0} )
     
     table.insert(self.pauseButtons, Button.new(
        "Continue",
        function () self.paused = false end,
        bx, by, buttonWidth, buttonHeight
    ))

     --Button 1 - Menu

     by = by + buttonHeight + buttonSpacing
   
     table.insert(self.pauseButtons, Button.new(
        "Menu",
        function () game:changeState("menu") end,
        bx, by, buttonWidth, buttonHeight
    ))

    --Reset all objects
    self.blasts = {}
    self.cities = {}
    self.guns = {}
    self.meteors = {}
    self.missiles = {}
    self.saucers = {}
    self.time = 0
    
     --Load Shader
    skyshader = love.graphics.newShader("skyshader.fs")
    skyshader:send("height", love.graphics.getHeight())

    --Add   guns and cities
    self.GUN_CITY_SPACING = (ww - 2*self.GUN_X_OFFSET)/6.0

    for pos=0,6 do
        --Guns at position 0, 3, 6
        if pos%3 == 0 then
            table.insert(self.guns, Gun.new(self.GUN_X_OFFSET + pos * self.GUN_CITY_SPACING))
        else
            --Must be a city othersise
            if (pos<=3) then
                citynumber = pos
            else
                citynumber = pos-1
            end            
            table.insert(self.cities, citynumber, City.new(self.GUN_X_OFFSET + pos * self.GUN_CITY_SPACING))
        end
    end

    --Set Meteor Countdown to 0 - spawn a meteor right away
    meteor_countdown = 0
end

function play:exited()
end

function play:draw()
    ww, wh = love.graphics.getDimensions()
   
    --Draw Shader Background
    love.graphics.setShader(skyshader)
    love.graphics.rectangle('fill', 0,0,ww, wh)
    love.graphics.setShader()

    --Draw Background
    love.graphics.setColor(0.1,0.5,0.1,1)
    love.graphics.rectangle('fill',0,wh-self.GROUND_HEIGHT, ww, self.GROUND_HEIGHT)

    local NoGuns = 0
    for i, gun in ipairs(self.guns) do
        if gun.alive == true then 
            NoGuns = NoGuns + 1
        end
    end

    local NoCities = 0
    for i, city in ipairs(self.cities) do
        if city.alive == true then
            NoCities = NoCities + 1
        end
    end

    --Draw Guns
    for i, gun in pairs(self.guns) do
        gun:draw()
    end

    --Draw Cities
    for i, city in ipairs(self.cities) do
        city:draw()
    end

    --Draw Missiles
    for mi, missile in ipairs(self.missiles) do
        missile:draw()
    end

    --Draw Blasts
    for i, blast in ipairs(self.blasts) do
        blast:draw()
    end

    --Draw Meteors
    for i, meteor in ipairs(self.meteors) do 
        meteor:draw()
    end

    --Draw Saucers
    for i, saucer in ipairs(self.saucers) do
        saucer:draw()
    end

    love.graphics.setColor(unpack(self.textColor))
    love.graphics.print(string.format("%.3f", self.time), self.font, wh*0.02, wh*0.02)

    love.graphics.setColor(1,1,1,1)

    --Draw Pause Menu
    if self.paused == true then
        
        love.graphics.setColor(0,0.5,0.0, 0.5)
        love.graphics.rectangle("fill", 0, 0, ww, wh)
        
        for i, button in ipairs(self.pauseButtons) do
            button:draw()
        end 
    end
end

function play:mousepressed(x, y, button, istouch)
    if self.paused == true then
        for i, button in ipairs(self.pauseButtons) do
            if button:isInside(mx, my) then
                button.fn(self)
                break
            end
        end
    else
        if button == 1 then
            play:addMissile(x,y)
        end
    end
end

function play:addMissile(ex, ey)
  
    local gunOrder = getGunOrder(ex)

    for i, gun in ipairs(gunOrder) do
        if self.guns[gun].alive == true then
            if self.guns[gun].timer <= 0 then
                table.insert(self.missiles, Missile.new(self.guns[gun], ex, ey))
                self.guns[gun]:startCoolDown()
                break
            end
        end  
    end
end

function play:keypressed(key)
    if key == "escape" then
        self.paused = not self.paused
    end
    if key == "." then
        game:changeState ( "gameOver" )
    end
end

function play:update(dt)
    --Dont update if paused
    if self.paused == true then 
        mx, my = love.mouse.getPosition()
        for i, button in ipairs(self.pauseButtons) do
            if button:isInside(mx, my) then
                button.isHot = true
            else
                button.isHot = false
            end
        end
        return 
    end

    --Check if all guns and cities are destroyed
    local alive = false
    for i, gun in ipairs(self.guns) do
        if gun.alive == true then 
            alive = true
            break
        end
    end

    for i, city in ipairs(self.cities) do
        if city.alive == true then
            alive = true
            break
        end
    end

    if alive == false then
        game:changeState ( "gameOver" )
    end
        --update time
        self.time = self.time + dt
    
        --send time to shader
        skyshader:send("time", self.time)

    --Blasts
    for i, blast in ipairs(self.blasts) do
        blast:update(dt)
        if blast.alive == false then
            table.remove(self.blasts , i)
        end
    end

    --Add Meteors
    if meteor_countdown <= 0 then
        if #self.meteors < 50 then
            --Get Random structure index, form 0 to 6
            local pos = math.random(0, 6)
            if pos%3 == 0 then
                --Targeting a gun
                pos = pos/3+1
                table.insert(self.meteors, Meteor.new(self.guns[pos]))
            else
                --Targeting a City
                if pos > 3 then pos  = pos - 1 end
                table.insert(self.meteors, Meteor.new(self.cities[pos]))
            end

            --table.insert(self.meteors, Meteor.new(target))
            local meteorTime = math.random(0.2, 1.0)
            local timeDifficulty = 1 / (self.time/15 + 1)
            meteor_countdown = meteorTime * timeDifficulty
        end
    else
        meteor_countdown = meteor_countdown - dt
    end

    if #self.saucers == 0 then
        table.insert(self.saucers, Saucer.new())
    end

    --Missiles
    for i, missile in ipairs(self.missiles) do
        missile:update(dt)
        if missile.alive == false then
            table.insert(self.blasts, Blast.new(missile.targetx, missile.targety))
            table.remove(self.missiles, i)
        end
    end

    --Check for Blast Collisions
    for bi, blast in ipairs(self.blasts) do
        for mi, meteor in ipairs(self.meteors) do
            if blast:hasDestroyed(meteor) then 
                --Meteor descruction
                table.remove(self.meteors, mi)
            end
        end

        for si, saucer in ipairs(self.saucers) do
            if blast:hasDestroyed(saucer) then
                --Saucer Destruction
                --Create new large blast
                blast = Blast.new(saucer.x, saucer.y)
                blast.MAX_SIZE = blast.MAX_SIZE*2.5
                table.insert(self.blasts, blast)
                table.remove(self.saucers, si)
            end
        end
    end

    --Updating for Meteors
    for i, meteor in ipairs(self.meteors) do
        meteor:update(dt)
        if meteor.alive == false then
            table.remove (self.meteors, i)
        end
    end

    --Update Saucer
    for i, saucer in ipairs(self.saucers) do
        saucer:update(dt)
        if saucer.alive == false then
            table.remove (self.saucers, i)
        end
    end

    --Update Guns
    for i, gun in ipairs(self.guns) do
        gun:update(dt)
    end
end

--Gest the order of the guns to check for when firing, based on distance
function getGunOrder (x)
    local gunOrder = {}

    local half = love.graphics.getWidth()/2
    local third = half*2/3

    if  x > third and x < third*2 then
        --Middle Gun is shot first
        table.insert(gunOrder,2)

        --Add for in outer guns
        if x/half < 1 then
            --Left hand gun first
            table.insert(gunOrder, 1)
            table.insert(gunOrder, 3)
        else
            --Right hand gun first
            table.insert(gunOrder, 3)
            table.insert(gunOrder, 1)
        end
    else
        --outer gun shoots first, either left of right hand side
        if x/half < 1 then
            --Starting form left hand side
            table.insert(gunOrder, 1)
            table.insert(gunOrder, 2)
            table.insert(gunOrder, 3)
        else
            --Starting form right hand side
            table.insert(gunOrder, 3)
            table.insert(gunOrder, 2)
            table.insert(gunOrder, 1)
        end
    end
           
    return gunOrder
end

return play
