local menu = {
    message = ""

}

function menu:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("This is the menu, press [SPACE] to play, [ESC] to quit. "..os.date())
    love.graphics.print(self.message, 0, 20)

    love.graphics.print("Press 1. to Play", 0, 40)
    love.graphics.print("Press 2. for Settings", 0, 60)
    love.graphics.print("Press 3. for Scoreboards", 0, 80)
    love.graphics.print("Press 4. for Credits", 0, 100)
end

function menu:set_message(message)
    self.message = message
end

function menu:keypressed(key)
    if key == "space" then
        game:changeState ("play")
    end
    if key == "escape" then
        love.event.quit(0)
    end
    if key == "1" then
        game:changeState("play")
    end
    if key == "2" then
        game:changeState("settings")
    end
    if key == "3" then
        game:changeState("scoreboard")
    end

    if key == "4" then
        game:changeState("credits")
    end

end

return menu

--Local table for menu
--when using as require, creates an encapuslted version