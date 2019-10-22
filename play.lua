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
    blastsx={},
    citiesx={},
    meteorsx={},
    gunsx={},
    missilesx={},
    
    --Object form Exgternal Classes
    blasts={},
    cities={},
    guns={},
    meteors={},
    missiles={},

    meteorCount=0,

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

    --Add   gunsx and citiesx
    self.GUN_CITY_SPACING = (window_width - 2*self.GUN_X_OFFSET)/6.0

    for pos=0,6 do
        --Guns at position 0, 3, 6
        if pos%3 == 0 then
            local gun = 
            {
                x = self.GUN_X_OFFSET + pos * self.GUN_CITY_SPACING,
                destroyed = false

            }
            table.insert(self.gunsx, 1 + pos / 3, gun)

            table.insert(self.guns, Gun.new(self.GUN_X_OFFSET + pos * self.GUN_CITY_SPACING, love.graphics.getHeight()-self.GUN_HEIGHT))
        else
            --Must be a city othersise
            if (pos<=3) then
                citynumber = pos
            else
                citynumber = pos-1
            end
            local city = 
            {
                x = self.GUN_X_OFFSET + pos * self.GUN_CITY_SPACING,
                destroyed = false
            }
            table.insert(self.citiesx, citynumber, city)
            
            table.insert(self.cities, citynumber, City.new(self.GUN_X_OFFSET + pos * self.GUN_CITY_SPACING, love.graphics.getHeight()-self.GUN_HEIGHT))
        end
    end

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

    --Draw Guns
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("This is the game, pres [ESC] to exit to menu.")
    love.graphics.rectangle("fill", self.player.x, self.player.y, 20, 20)

     --Draw Guns
    love.graphics.setColor(0.5,0.5,0.5,1)
    for gi, gun in pairs(self.gunsx) do
        love.graphics.circle('fill', gun.x, window_height-self.GUN_HEIGHT + self.GUN_WIDTH/2, self.GUN_WIDTH*0.4)
        love.graphics.rectangle('fill', gun.x-self.GUN_WIDTH/2, window_height-self.GUN_HEIGHT+self.GUN_WIDTH*0.6, self.GUN_WIDTH, self.GUN_WIDTH)
    end
    for i, gun in pairs(self.guns) do
        gun:draw()
    end

    --Draw Cities
    love.graphics.setColor(0.4,0.4,0.4,1.0)
    for ci, city in pairs(self.citiesx) do
        love.graphics.rectangle('fill', city.x-self.CITY_SIZE/2.0, window_height-self.CITY_SIZE, self.CITY_SIZE, self.CITY_SIZE)
    end

    for i, city in ipairs(self.cities) do
        city:draw()
    end


    --Draw Missiles
    love.graphics.setColor(1,0,0,1)
    for mi, missile in pairs(self.missilesx) do
        love.graphics.line(missile.startx, missile.starty, missile.x, missile.y)
        love.graphics.circle("fill", missile.x, missile.y, 3)
    end


    --Draw Blasts
    
    for i, blast in ipairs(self.blastsx) do 
        love.graphics.setColor(love.math.random(0.7, 1.0),love.math.random(0,0.4),0,1)
        love.graphics.circle("fill", blast.x, blast.y, blast.size)
    end

    for i, blast in ipairs(self.blasts) do
        blast:draw()
    end


    --Draw Meteors
    love.graphics.setColor(0.5,0.5,0.3,1)
    for i, meteor in ipairs(self.meteorsx) do 
        love.graphics.circle("fill", meteor.x, meteor.y, self.METEOR_SIZE)
    end

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
    local window_width,  window_height = love.graphics.getDimensions()
    local x3 = window_width/3
    local gun=0;

    if ex < x3 then
        gun=1
    elseif ex > window_width-x3 then
        gun=3
    else
        gun=2
    end

    --TODO - Gun Cooldown Checks

    local sx = self.gunsx[gun].x
    local sy = window_height-self.GUN_HEIGHT

    --Only allow shooting slightlu up
    ey = math.min(ey, window_height-self.GUN_HEIGHT-1)

    local stepx = ex-sx
    local stepy = ey-sy

    local len = math.pow(stepx*stepx + stepy*stepy, 0.5)

    local missile = {
        startx  = sx,
        starty  = sy,
        targetx = ex,
        targety = ey,
        deltax = stepx * self.MISSILE_SPEED/len,
        deltay = stepy * self.MISSILE_SPEED/len,
        x = sx,
        y = sy

    }
    table.insert(self.missilesx, missile)

    table.insert(self.missiles, Missile.new(self.guns[1], ex, ey))
end


function play:addBlast(ex, ey)
    local blast = {
        x = ex,
        y = ey,
        size=1,
        growing = true;
    }
    table.insert(self.blastsx, blast)

    --Blast Object
    table.insert(self.blasts, Blast.new(ex, ey) )
end


function play:keypressed(key)
    if key == "escape" then
        game:change_state ( "menu" )
    end

    if key == "space" then
        play:addBlast(self.player.x, self.player.y)
    end

end

function play:update(dt)
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
    for i, blast in ipairs(self.blastsx) do
        if blast.growing == true then
            blast.size = blast.size + dt * self.BLAST_GROWSPEED
            if blast.size > self.BLAST_SIZE_MAX then
                blast.size = self.BLAST_SIZE_MAX
                blast.growing = false
            end
        else 
            blast.size = blast.size - dt*self.BLAST_SHRINKSPEED
            if blast.size < 0 then
                table.remove(self.blastsx, i)
            end
        end
    end

    for i, blast in ipairs(self.blasts) do
        blast:update(dt)
        if blast.alive ~= true then
            table.remove(self.blasts
    , i)
        end
    end

    --Add Meteors
    if meteor_countdown <= 0 then
    
        if self.meteorCount < 200 then
            local meteor = 
            {
                x = love.math.random(self.METEOR_SIZE/2,window_width-self.METEOR_SIZE/2),
                --y = love.math.random(self.METEOR_SIZE/2,window_height-self.METEOR_SIZE/2)
                y=0
            }
            table.insert(self.meteorsx, meteor)

            

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
            meteor_countdown = math.random(0.5, 1.5)
        end
    else
        meteor_countdown = meteor_countdown - dt
    end


    --Missiles
    for mi, missile in pairs(self.missilesx) do
        missile.x = missile.x + missile.deltax * dt
        missile.y = missile.y + missile.deltay * dt
        --Move missile, and check for location.

        --Check if missilesx traveled enough
        if  missile.y-missile.starty < missile.targety-missile.starty then
            play:addBlast(missile.targetx, missile.targety)
            table.remove(self.missilesx, mi)
        end

    end

    for i, missile in ipairs(self.missiles) do
        missile:update(dt)
        if missile.alive == false then
            table.insert(self.blasts, Blast.new(missile.targetx, missile.targety))
            table.remove(self.missiles, i)
        end
    end


    --Check for Blast Collisions

    for bi, blast in pairs(self.blastsx) do
        CheckDistance2 = math.pow((blast.size + self.METEOR_SIZE),2)
        for mi, meteor in pairs(self.meteorsx) do
            distance2 = math.pow((meteor.x - blast.x), 2) + math.pow((meteor.y - blast.y), 2)
            if distance2 <= CheckDistance2 then
                table.remove(self.meteorsx,mi)
                self.meteorCount = self.meteorCount - 1
            end
        end
    end

    for bi, blast in ipairs(self.blasts) do
        for mi, meteor in ipairs(self.meteors) do
            if blast:hasDestroyed(meteor) then 
                --Meteor descruction
                table.remove(self.meteors, mi)
            end
            --TODO - other destroyables
        end

    end

    --DropMeteors

    for mi, meteor in pairs(self.meteorsx) do
        meteor.y = meteor.y + self.METEOR_FALLSPEED * dt

        if meteor.y > window_height + self.METEOR_SIZE then
            meteor.y = -self.METEOR_SIZE
        end
    end

    --Updating for Meteors
    for i, meteor in pairs(self.meteors) do
        meteor:update(dt)
        if meteor.alive == false then
            table.remove (self.meteors, i)
        end
    end

end


return play

--Local table for play
--when using as require, creates an encapuslted version