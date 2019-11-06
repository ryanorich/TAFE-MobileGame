local Button = require("button")

local menu = {
    message = "",
    buttons = {},
    BGColor = {0,0.2,0,1.0}
}

function menu:mousepressed(mx, my, button, istouch)

    for i, button in ipairs(self.buttons) do
        if button:isInside(mx, my) then
            button.fn()
            break
        end
    end
end

function menu:entered()
    
    --Setting up main menu button - 4 of 
    self.buttons = {}

    local noOfButtons = 4

    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    local buttonWidth = ww * 0.4
    local buttonHeight = wh * 0.1
    local buttonSpacing = buttonHeight * 0.4


    local totalButtonHeight = noOfButtons * (buttonHeight + buttonSpacing) - buttonSpacing

    local bx = (ww - buttonWidth) * 0.5
    local by = (wh - totalButtonHeight) * 0.5

    Button.setColors( {0.3, 0.4, 0.3, 1.0}, {0.7, 0.9, 0.5, 1.0}, {0,0.2,0,1.0} )

    --Button #1 - Play
    table.insert(self.buttons, Button.new(
                    "Play",
                    function () game:changeState("play") end,
                    bx, by, buttonWidth, buttonHeight
                ))

    --Button #1 - Settings
    by = by + buttonHeight + buttonSpacing
    table.insert(self.buttons, Button.new(
                    "Settings",
                    function () game:changeState("settings") end,
                    bx, by, buttonWidth, buttonHeight
                ))
    
    --Button #1 - Scoreboard
    by = by + buttonHeight + buttonSpacing
    table.insert(self.buttons, Button.new(
                    "Scoreboard",
                    function () game:changeState("scoreboard") end,
                    bx, by, buttonWidth, buttonHeight
                ))

    --Button #1 - Credits
    by = by + buttonHeight + buttonSpacing
    table.insert(self.buttons, Button.new(
                    "Credits",
                    function () game:changeState("credits") end,
                    bx, by, buttonWidth, buttonHeight
                ))

    --Exit Button
    Button.setColors({0.2,0,0,1},{0.9,0.3,0.21},{1.0,0.1,0.0,1})
 
    local by = wh - buttonHeight * 1.5
    table.insert(self.buttons, Button.new(
                    "Exit",
                    menu.exitGame,--menu:exitGame(),
                    ww*0.8, by, ww*0.15, buttonHeight 
    ))
end

function menu:update(dt)
    mx, my = love.mouse.getPosition()
    for i, button in ipairs(self.buttons) do
        if button:isInside(mx, my) then
            button.isHot = true
        else
            button.isHot = false
        end
    end
end

function menu:draw()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()


    love.graphics.setColor(unpack(self.BGColor))
    love.graphics.rectangle("fill", 0, 0, ww, wh)

    love.graphics.setColor(1,1,1,1)
    love.graphics.print("This is the menu, press [SPACE] to play, [ESC] to quit. "..os.date())
    love.graphics.print(self.message, 0, 20)

    love.graphics.print(ww.."x"..wh, 0, 40)

    for i, button in ipairs(self.buttons) do
        button:draw()
    end

end

function menu:set_message(message)
    self.message = message
end

function menu:keypressed(key)

    if key == "escape" then
        menu.exitGame()
    end


end

function menu:exitGame()
    love.event.quit()
end

return menu

--Local table for menu
--when using as require, creates an encapuslted version