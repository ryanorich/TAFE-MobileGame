local Meteor = require( 'meteor')
local Gun = require ('gun')
local Missile = require ('missile')
local City = require ('city')
local Blast = require ('blast')

--Local parameters for play
local play = 
{
    player = 
    {
        x = 0,
        y = 0
    },
    
    --Local objects to to be changed.
   -- blastsx={},
   --s citiesx={},

   -- gunsx={},
   -- missilesx={},
    
    --Object form Exgternal Classes
    blasts={},
    cities={},
    guns={},
    meteors={},
    missiles={},

    meteorCount=0,

    time = 0,

    PLAYER_SPEED = 500,

    BLAST_SIZE_MAX = 60,
    BLAST_GROWSPEED = 75,
    BLAST_SHRINKSPEED = 90,

    METEOR_SIZE = 5,
    METEOR_FALLSPEED = 50,

    GROUND_HEIGHT = 20,
    GUN_WIDTH = 50,
    GUN_HEIGHT =80,
    GUN_X_OFFSET = 50,
    GUN_CITY_SPACING = 0, --Need to calculate

    CITY_SIZE = 50,

    MISSILE_SIZE = 4,
    MISSILE_SPEED = 500
}

--Startup
function play:entered()
    window_width, window_height = love.graphics.getDimensions()

    --Add Player
    self.player = {
        x = 0,
        y = 0
    }

    --Add   guns and cities
    self.GUN_CITY_SPACING = (window_width - 2*self.GUN_X_OFFSET)/6.0

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


--Note - User method calls for other states.
function play:exited()
    game.states.menu:set_message("The player was at " .. self.player.x .. ", " .. self.player.y)
end

function play:draw()

    window_width, window_height = love.graphics.getDimensions()
    
    --Draw Background
    love.graphics.setColor(0.2,1,0,1)
    love.graphics.rectangle('fill',0,window_height-self.GROUND_HEIGHT, window_width, self.GROUND_HEIGHT)

    --Draw Reticle
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("This is the game, pres [ESC] to exit to menu.")
    love.graphics.print("Time is now : ".. self.time, 0, 20)
    love.graphics.print("Meteors : ".. #self.meteors, 0, 40)
    love.graphics.print("Missiles : ".. #self.missiles, 0, 60)
    love.graphics.print("Blasts : ".. #self.blasts, 0, 80)
    love.graphics.print("Guns : ".. #self.guns, 0, 100)
    love.graphics.print("Cities : ".. #self.cities, 0, 120)
    love.graphics.rectangle("fill", self.player.x, self.player.y, 20, 20)

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
end

function play:mousepressed(x, y, button, istouch)
    if button == 1 then
        play:addMissile(x,y)
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

function play:addBlast(ex, ey)
    --Blast Object
    table.insert(self.blasts, Blast.new(ex, ey) )
end

function play:keypressed(key)
    if key == "escape" then
        game:change_state ( "menu" )
    end
    if key == "space" then
        play:addMissile(self.player.x, self.player.y)
    end
end

function play:update(dt)

    --update time
    self.time = self.time + dt

    window_width, window_height = love.graphics.getDimensions()

    --Player Movement
    if love.keyboard.isDown("w") then
        self.player.y = self.player.y - self.PLAYER_SPEED * dt
    end
    if love.keyboard.isDown("s") then
        self.player.y = self.player.y + self.PLAYER_SPEED * dt
    end
    if love.keyboard.isDown("a") then
        self.player.x = self.player.x - self.PLAYER_SPEED * dt
    end
    if love.keyboard.isDown("d") then
        self.player.x = self.player.x + self.PLAYER_SPEED * dt
    end

    --Blasts

    for i, blast in ipairs(self.blasts) do
        blast:update(dt)
        if blast.alive == false then
            table.remove(self.blasts , i)
        end
    end

    --Add Meteors
    if meteor_countdown <= 0 then
    
        if self.meteorCount < 200 then
  

            --GER Random structure index, form 0 to 6
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

            self.meteorCount = self.meteorCount + 1
            meteor_countdown = math.random(0.2, 1.0)
        end
    else
        meteor_countdown = meteor_countdown - dt
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
            --TODO - other destroyables
        end
    end

    --Updating for Meteors
    for i, meteor in pairs(self.meteors) do
        meteor:update(dt)
        if meteor.alive == false then
            table.remove (self.meteors, i)
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

    if  math.floor(x/3) == 1 then
        --Middle Gun is shot first
        table.insert(gunOrder,2)

        --Add in outer guns
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
        --Starting form eight left of right hand side
        if x/half < 1 then
            --Startign form Left Hand Side
            table.insert(gunOrder, 1)
            table.insert(gunOrder, 2)
            table.insert(gunOrder, 3)

        else
            --Starting form Right Hand side

            table.insert(gunOrder, 3)
            table.insert(gunOrder, 2)
            table.insert(gunOrder, 1)

        end
    end
           

    return gunOrder
end

return play

--Local table for play
--when using as require, creates an encapuslted version