--Local parameters for play
local play = {
    player = {
        x = 0,
        y = 0
    }
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

    love.graphics.print("This is the game, pres [SPACE] to exit to menu.")
    love.graphics.rectangle("fill", self.player.x, self.player.y, 20, 20)
end


function play:keypressed(key)
    if key == "space" then
        game:change_state ( "menu" )
    end

end

function play:update(dt)
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
end


return play

--Local table for play
--when using as require, creates an encapuslted versio