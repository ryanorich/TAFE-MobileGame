--Local parameters for play
local play = {
    player = {
        x = 0,
        y = 0
    },
    
    explosions={}

    
}

function play:entered()
    self.player = {
        x = 0,
        y = 0
    }
end

--Note - User method calls for other states.
function play:exited()
    game.states.menu:set_message("The player was at " .. self.player.x .. ", " .. self.player.y)
end

function play:draw()

    love.graphics.print("This is the game, pres [ESC] to exit to menu.")
    love.graphics.rectangle("fill", self.player.x, self.player.y, 20, 20)

    for i, explosion in ipairs(self.explosions) do 
        love.graphics.circle("fill", explosion.x, explosion.y, explosion.size)
    end

end

function play:mousepressed(x, y, button, istouch)
    if button == 1 then
       play:addExplosion(x, y)  
    end
end

function play:addExplosion(ex, ey)
    local explosion = {
        x = ex,
        y = ey,
        size=1,
        growing = true;
    }
    table.insert(self.explosions, explosion)
end


function play:keypressed(key)
    if key == "escape" then
        game:change_state ( "menu" )
    end

    if key == "space" then
        play:addExplosion(self.player.x, self.player.y)
    end

end

function play:update(dt)
    --Player Movement
    if love.keyboard.isDown("w") then
        self.player.y = self.player.y - 500 * dt
    end
    if love.keyboard.isDown("s") then
        self.player.y = self.player.y + 500 * dt
    end
    if love.keyboard.isDown("a") then
        self.player.x = self.player.x - 500 * dt
    end
    if love.keyboard.isDown("d") then
        self.player.x = self.player.x + 500 * dt
    end

    for i, explosion in ipairs(self.explosions) do
        if explosion.growing == true then
            explosion.size = explosion.size + dt*50
            if explosion.size > 50 then
                explosion.size = 50
                explosion.growing = false
            end
        else 
            explosion.size = explosion.size - dt*80
            if explosion.size < 0 then
                table.remove(self.explosions, i)
            end
        end
    end


end


return play

--Local table for play
--when using as require, creates an encapuslted versio