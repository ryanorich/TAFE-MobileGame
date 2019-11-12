local Button = require("button")

local menu = {
    message = "",
    buttons = {},
    BGColor = {0,0.2,0,1.0},
    textColor = {0.5,0.9,0.4,1.0},
    BGMusic = love.audio.newSource("sfx/BGMusic.mp3","static"),
    titleFont = love.graphics.newFont(love.graphics.getHeight()*0.1),
}

menu.BGMusic:setLooping(true)

function menu:mousepressed(mx, my, button, istouch)

    for i, button in ipairs(self.buttons) do
        if button:isInside(mx, my) then
            if game.states.settings.soundOn then
                button:playPressed()
            end
            button.fn()
            break
        end
    end
end

function menu:entered()
    if game.states.settings.musicOn then
        self.BGMusic:play()
    else
        self.BGMusic:pause()
    end

    self.blip = love.audio.newSource("sfx/Blip.wav", "static")
    print (self.blip)
    
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

    Button.setColors( {0.4, 0.5, 0.3, 1.0}, {0.8, 0.9, 0.5, 1.0}, {0,0.2,0,1.0} )

    --Button #1 - Play
    button = Button.new(
        "Play",
        function () game:changeState("play") end,
        bx, by, buttonWidth, buttonHeight
    )
    button:setSound("blipup")
    table.insert(self.buttons, button)

    --Button #2 - Settings
    by = by + buttonHeight + buttonSpacing
    button = Button.new(
        "Settings",
        function () game:changeState("settings") end,
        bx, by, buttonWidth, buttonHeight)
    button:setSound("blipup")
    table.insert(self.buttons, button)
    
    --Button #3 - Scoreboard
    by = by + buttonHeight + buttonSpacing
    button = Button.new(
        "Scoreboard",
        function () game:changeState("scoreboard") end,
        bx, by, buttonWidth, buttonHeight
    )
    button:setSound("blipup")
    table.insert(self.buttons, button)

    --Button #4 - Credits
    by = by + buttonHeight + buttonSpacing
    button = Button.new(
        "Credits",
        function () game:changeState("credits") end,
        bx, by, buttonWidth, buttonHeight
    )
    button:setSound("blipup")
    table.insert(self.buttons, button)

    --Exit Button
    Button.setColors({0.2,0,0,1},{0.4,0.3,0.2,1},{1.0,0.1,0.0,1})
 
    local by = wh - buttonHeight * 1.5
    button = Button.new(
        "Exit",
        
        menu.exitGame,
        ww*0.8, by, ww*0.15, buttonHeight 
        )
    button:setSound("blipdown")
    table.insert(self.buttons, button )
end

function menu:update(dt)
    mx, my = love.mouse.getPosition()
    for i, button in ipairs(self.buttons) do
        if button:isInside(mx, my) then
            if button.isHot == false then
                button.isHot = true
                if game.states.settings.soundOn then
                    button:playHot()
                end
            end
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

    for i, button in ipairs(self.buttons) do
        button:draw()
    end

    love.graphics.setColor(unpack(self.textColor))
    local title = "METEOR CONTROL"
    local tw = self.titleFont.getWidth(self.titleFont, title)
    local tx = (ww - tw) * 0.5
    local ty = wh * 0.05

    love.graphics.print(title,  self.titleFont,tx, ty)
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
    --Allow time for button sound
    love.timer.sleep(0.2)
    love.event.quit()
end

return menu
