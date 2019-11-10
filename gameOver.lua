local Button = require("button")

local gameOver = {
    isHighScore = false,
    BGColor = {0,0.2,0,1.0},
    textColor = {0.5,0.9,0.4,1.0},
    buttons = {},
    titleFont
}

--Check if the score is eligable for a high Score
function gameOver:entered()
    --Start the BG Music
    if game.states.settings.musicOn then
        game.states.menu.BGMusic:play()
    else
        game.states.menu.BGMusic:pause()
    end

    self.buttons = {}
    isHighScore = game.states.scoreboard:isHighScore(game.states.play:getTimeScore())

    Button.setColors( {0.3, 0.4, 0.3, 1.0}, {0.7, 0.9, 0.5, 1.0}, {0,0.2,0,1.0} )

    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    local buttonWidth = ww * 0.4
    local buttonHeight = wh * 0.1

    local bx = (ww - buttonWidth) * 0.5
    local by = wh - buttonHeight * 1.5

    --Button #1 - Continue
    button = Button.new(
        "Continue",
        function () 
            if isHighScore == true then
                game:changeState ("enterName")
            else
                game:changeState ("menu")
            end
        end,
        bx, by, buttonWidth, buttonHeight
    )
    button:setSound("blipup")
    table.insert(self.buttons, button)

    self.titleFont = love.graphics.newFont(wh*0.2)

end

function gameOver:draw()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    
    love.graphics.setColor(unpack(self.BGColor))
    love.graphics.rectangle("fill", 0, 0, ww, wh)


    --button:setColor()
    --love.graphics.setColor


    -- love.graphics.setColor(1,1,1,1)
    -- if isHighScore == true then
    --     love.graphics.print("This is a high score!", 0, 20)
    -- else
    --     love.graphics.print("This is NOT a high score.", 0, 40)
    -- end

    for i, button in ipairs(self.buttons) do
        button:draw()
    end

    love.graphics.setColor(unpack(self.textColor))
    local title = "GAME\nOVER"
    local tw = self.titleFont.getWidth(self.titleFont, title)
    local tx = (ww - tw) * 0.5
    local ty = wh * 0.2

    love.graphics.print(title,  self.titleFont,tx, ty)

end


function gameOver:keypressed(key)

    if key == "escape" then
        if isHighScore == true then
            game:changeState ("enterName")
        else
            game:changeState ("menu")
        end
    end
end

function gameOver:update(dt)
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

function gameOver:mousepressed(mx, my, button, istouch)

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

return gameOver