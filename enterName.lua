local Button = require("button")

local enterName = {
    BGColor = {0,0.2,0,1.0},
    textColor = {0.5,0.9,0.4, 1.0},
    name = "",
    MAX_LENGTH = 20,
    buttons = {},
    font = {}
}

function enterName:entered()
    self.buttons = {}
    self.name = ""

    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    self.font = love.graphics.newFont(wh*0.05)

    local buttonWidth = ww * 0.3
    local buttonSpacing = ww * 0.1
    local buttonHeight = wh * 0.1

    local bx = (ww - buttonWidth*2 - buttonSpacing) * 0.5
    local by = 0.9 * wh - buttonHeight

    Button.setColors( {0.4, 0.5, 0.3, 1.0}, {0.8, 0.9, 0.5, 1.0}, {0,0.2,0,1.0} )

    --Enter Button
    button = Button.new(
        "Enter",
        function () 
            game.states.scoreboard:addScore(tonumber(string.format("%.3f",game.states.play:getTime())), self.name)
            game:changeState("scoreboard")
        end,
        bx, by, buttonWidth, buttonHeight
    )
    button:setSound("blipup")
    table.insert(self.buttons, button )

    bx = bx + buttonSpacing + buttonWidth
    --Cancel Button
    button = Button.new(
        "Cancel",
        function () game:changeState("menu") end,
        bx, by, buttonWidth, buttonHeight
    )
    button:setSound("blipdown")
    table.insert(self.buttons, button )

    --Keys
    buttonWidth = ww/10.0*0.8
    buttonSpacing = ww/10.0*0.2

    bx = buttonSpacing * 0.5
    by = wh*0.3

    local topRow = "QWERTYUIOP"
    local middleRow = "ASDFGHJKL"
    local bottomRow = "ZXCVBNM"

    for i = 1, #topRow do
        table.insert(self.buttons, Button.new(
            string.sub(topRow, i, i),
            enterName.addLetter,
            bx + (i-1)*(buttonWidth + buttonSpacing),
            by, buttonWidth, buttonHeight
        ))
    end

    bx = buttonSpacing * 2.5
    by = by + buttonHeight + buttonSpacing

    for i = 1, #middleRow do
        table.insert(self.buttons, Button.new(
            string.sub(middleRow, i, i),
            enterName.addLetter,
            bx + (i-1)*(buttonWidth + buttonSpacing),
            by, buttonWidth, buttonHeight
        ))
    end

    bx = buttonSpacing * 4.5
    by = by + buttonHeight + buttonSpacing

    for i = 1, #bottomRow do
        table.insert(self.buttons, Button.new(
            string.sub(bottomRow, i, i),
            enterName.addLetter,
            bx + (i-1)*(buttonWidth + buttonSpacing),
            by, buttonWidth, buttonHeight
        ))
    end

    by = by + buttonHeight + buttonSpacing
    buttonWidth = ww * 0.6
    bx = (ww - buttonWidth) * 0.5

    table.insert(self.buttons, Button.new(
       "space",
        enterName.addLetter,
        bx, by, buttonWidth * 0.7, buttonHeight
    ))

    table.insert(self.buttons, Button.new(
        "back",
         enterName.removeLetter,
         bx + buttonWidth*0.8, by, buttonWidth*0.2, buttonHeight
     ))
end

--Operate on each key that is pressed
function enterName:keypressed(key)
    if key == "escape" then
        game:changeState("menu")
    elseif key == "return" then
        --Add name and score to high scores
        game.states.scoreboard:addScore(tonumber(string.format("%.3f",game.states.play:getTime())), self.name)
        game:changeState("scoreboard")
    elseif key == "space" then
        if string.len(self.name) > 0  and string.len(self.name) < self.MAX_LENGTH then
            self.name = self.name.." "
        end
    elseif key == "delete" or key == "backspace" then
        self.name = string.sub(self.name, 1, -2)
    
    else 
        self:addLetter(key)
    end
end

function enterName:addLetter(letter)
    if string.len(letter) == 1  and string.find(letter, "%a") ~= nill then
        --adding letter. 
        if string.len(self.name) < self.MAX_LENGTH then
            self.name = self.name..string.upper(letter)
        end
    elseif letter == " " then
        --adding space
        if string.len(self.name) < self.MAX_LENGTH then
            self.name = self.name.." "
        end
    end
end

function enterName:removeLetter()
    if #self.name > 0 then
        self.name = string.sub(self.name, 1, -2)
    end
end

function enterName:draw()

    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    love.graphics.setColor(unpack(self.BGColor))
    love.graphics.rectangle("fill", 0, 0, ww, wh)

    for i, button in ipairs(self.buttons) do
        button:draw()
    end

    love.graphics.setColor(unpack(self.textColor))

    local title = "Enter Name:"
    local tx = (ww - self.font.getWidth(self.font, title)) * 0.5
    local ty = self.font.getHeight( self.font, title) * 0.5

    love.graphics.print(title, self.font, tx, ty)

    local tx = (ww - self.font.getWidth(self.font, self.name)) * 0.5
    local ty = ty * 3

    love.graphics.print(self.name, self.font, tx, ty)
end

function enterName:update(dt)
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

function enterName:mousepressed(mx, my, button, istouch)
    for i, button in ipairs(self.buttons) do
        if button:isInside(mx, my) then
            if game.states.settings.soundOn then
                button:playPressed()
            end
            --Chcke which type of button
            if #button.text == 1  then
                --This is a letter button
                button.fn(self,button.text)
                break
            elseif button.text == "space" then
                --Space button pressed
                button.fn(self," ")
                break
            else
                button.fn(self)
                break
            end
        end
    end
end

return enterName