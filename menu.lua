local menu = {
    message = ""

}

function menu:draw()
    love.graphics.print("This is the menu, press [SPACE] to play.")
    love.graphics.print(self.message, 0, 20)
end

function menu:set_message(message)
    self.message = message
end

function menu:keypressed(key)
    if key == "space" then
        game:change_state ("play")
    end

end

return menu

--Local table for menu
--when using as require, creates an encapuslted version