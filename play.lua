--Local parameters for play
local play = {
    player = {
        x = 0,
        y = 0
    },
    
    blasts={},
    meteors={},
    meteorCount=0,
    missiles={},
    guns={},
    
    PLAYER_SPEED = 500,

    BLAST_SIZE_MAX = 50,
    BLAST_GROWSPEED = 50,
    BLAST_SHRINKSPEED = 80,

    METEOR_SIZE = 5,
    METEOR_FALLSPEED = 200,

    GROUND_HEIGHT = 20,
    GUN_WIDTH = 50,
    GUN_HEIGHT =80,

    MISSILE_SIZE = 4,
    MISSILE_SPEED = 500


}

function play:entered()
    window_width, window_height = love.graphics.getDimensions()

    self.player = {
        x = 0,
        y = 0
    }

    local gun = 
    {
        x = 100
    }
    table.insert(self.guns,  1, gun)

    local gun = 
    {
        x = window_width/2,
    }
    table.insert(self.guns, 2, gun)
 
    local gun = 
    {
        x = window_width-100
    }
    table.insert(self.guns,  3, gun)
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
    love.graphics.setColor(0.5,0.5,0.5,1)
    for gi, gun in pairs(self.guns) do
        love.graphics.circle('fill', gun.x, window_height-self.GUN_HEIGHT + self.GUN_WIDTH/2, self.GUN_WIDTH*0.4)
        love.graphics.rectangle('fill', gun.x-self.GUN_WIDTH/2, window_height-self.GUN_HEIGHT+self.GUN_WIDTH*0.6, self.GUN_WIDTH, self.GUN_WIDTH)
    end


    --Draw Missiles
    love.graphics.setColor(1,0,0,1)
    for mi, missile in pairs(self.missiles) do
        love.graphics.line(missile.startx, missile.starty, missile.x, missile.y)
        love.graphics.circle("fill", missile.x, missile.y, 3)
    end


    --Draw Blasts
    love.graphics.setColor(1,0.5,0,1)
    for i, blast in ipairs(self.blasts) do 
        love.graphics.circle("fill", blast.x, blast.y, blast.size)
    end


    --Draw Meteors
    love.graphics.setColor(0.5,0.5,0.3,1)
    for i, meteor in ipairs(self.meteors) do 
        love.graphics.circle("fill", meteor.x, meteor.y, self.METEOR_SIZE)
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

    local sx = self.guns[gun].x
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
    table.insert(self.missiles, missile)
end


function play:addBlast(ex, ey)
    local blast = {
        x = ex,
        y = ey,
        size=1,
        growing = true;
    }
    table.insert(self.blasts, blast)
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
    for i, blast in ipairs(self.blasts) do
        if blast.growing == true then
            blast.size = blast.size + dt * self.BLAST_GROWSPEED
            if blast.size > self.BLAST_SIZE_MAX then
                blast.size = self.BLAST_SIZE_MAX
                blast.growing = false
            end
        else 
            blast.size = blast.size - dt*self.BLAST_SHRINKSPEED
            if blast.size < 0 then
                table.remove(self.blasts, i)
            end
        end
    end

    --Add Meteors
    if self.meteorCount < 20 then
        local meteor = 
        {
            x = love.math.random(self.METEOR_SIZE/2,window_width-self.METEOR_SIZE/2),
            y = love.math.random(self.METEOR_SIZE/2,window_height-self.METEOR_SIZE/2)
        }
        table.insert(self.meteors, meteor)
        self.meteorCount = self.meteorCount + 1
    end

    --Missiles
    for mi, missile in pairs(self.missiles) do
        missile.x = missile.x + missile.deltax * dt
        missile.y = missile.y + missile.deltay * dt
        --Move missile, and check for location.

        --Check if missiles traveled enough
        if  missile.y-missile.starty < missile.targety-missile.starty then
            play:addBlast(missile.targetx, missile.targety)
            table.remove(self.missiles, mi)
        end

    end


    --Check for Blast Collisions

    for bi, blast in pairs(self.blasts) do
        CheckDistance2 = math.pow((blast.size + self.METEOR_SIZE),2)
        for mi, meteor in pairs(self.meteors) do
            distance2 = math.pow((meteor.x - blast.x), 2) + math.pow((meteor.y - blast.y), 2)
            if distance2 <= CheckDistance2 then
                table.remove(self.meteors,mi)
                self.meteorCount = self.meteorCount - 1
            end

        end

    end

    

    
    --DropMeteors

    for mi, meteor in pairs(self.meteors) do
        meteor.y = meteor.y + self.METEOR_FALLSPEED * dt

        if meteor.y > window_height + self.METEOR_SIZE then
            meteor.y = -self.METEOR_SIZE
        end

    end



end


return play

--Local table for play
--when using as require, creates an encapuslted versio