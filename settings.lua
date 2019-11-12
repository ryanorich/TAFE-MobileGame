local Button = require("button")

local settings = {
    buttons = {},
    BGColor = {0,0.2,0,1.0},
    soundOn = true,
    musicOn = true
}

function settings:keypressed(key)
    if key == "escape" then
        game:changeState( "menu" )
    end
end

function settings:entered()
    self.buttons = {}
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    love.graphics.setColor(unpack(self.BGColor))
    love.graphics.rectangle('fill', 0, 0,ww, wh)
    love.graphics.setColor(1,1,1,1)
    
    local noOfButtons = 3

    local buttonWidth = ww * 0.4
    local buttonHeight = wh * 0.1
    local buttonSpacing = buttonHeight * 0.4
    local totalButtonHeight = noOfButtons * (buttonHeight + buttonSpacing) - buttonSpacing

    local bx = (ww - buttonWidth) * 0.5
    local by = (wh - totalButtonHeight) * 0.5

    --Button 1 - SFX
    Button.setColors( {0.4, 0.5, 0.3, 1.0}, {0.8, 0.9, 0.5, 1.0}, {0,0.2,0,1.0} )
     
     table.insert(self.buttons, Button.new(
        "Sound [ ... ]",
        settings.toggleSound,
        bx, by, buttonWidth, buttonHeight
    ))
    --Button 2 - Music
    by = by + buttonHeight + buttonSpacing
    table.insert(self.buttons, Button.new(
        "Music [ ... ]",
        settings.toggleMusic,
        bx, by, buttonWidth, buttonHeight
    ))
    
    --Button 3 - Menu
    
    local by = wh - buttonHeight * 1.5
    button = Button.new(
        "Menu",
        function () game:changeState("menu") end,
        bx, by, buttonWidth, buttonHeight
    )
    button:setSound("blipdown")
    table.insert(self.buttons, button ) 

    --Chec the actual settings to set the text
    self:updateButtonText()
end

function settings:draw()
  
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    love.graphics.setColor(unpack(self.BGColor))
    love.graphics.rectangle('fill', 0, 0,ww, wh)

    for i, button in ipairs(self.buttons) do
        button:draw()
    end
end

function settings:update(dt)
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

function settings:mousepressed(mx, my, button, istouch)

    for i, button in ipairs(self.buttons) do
        if button:isInside(mx, my) then
            button.fn(self)
            if game.states.settings.soundOn then
                button:playPressed()
            end
            break
        end
    end
end

function settings:toggleSound()
    self.soundOn = not self.soundOn
    self:updateButtonText()
end

function settings:toggleMusic()
    self.musicOn = not self.musicOn
    self:updateButtonText()
end

function settings:updateButtonText()
    if self.soundOn == true then
        self.buttons[1]:changeText( "Sound [ ON ]")
    else
        self.buttons[1]:changeText( "Sound [ OFF ]")
    end

    if self.musicOn == true then
        self.buttons[2].text = "Music [ ON ]" 
    else
        self.buttons[2].text = "Music [ OFF ]"
    end

    if self.musicOn then
        game.states.menu.BGMusic:play()
    else
        game.states.menu.BGMusic:pause()
    end

end

return settings