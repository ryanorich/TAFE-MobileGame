local Button = require("button")

local credits = {
    buttons = {},
    BGColor = {0,0.2,0,1.0},
    textColor = {0.5,0.9,0.4,1.0},
    text = ""
}

function credits:keypressed(key)
    if key == "escape" then
        game:changeState("menu")
    end
end

function credits:entered()
    self.buttons = {}
    Button.setColors( {0.4, 0.5, 0.3, 1.0}, {0.8, 0.9, 0.5, 1.0}, {0,0.2,0,1.0} )

    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    local buttonWidth = ww * 0.4
    local buttonHeight = wh * 0.1

    local bx = (ww - buttonWidth) * 0.5
    local by = wh - buttonHeight * 1.5

   --Button #1 - BACK TO Menu
   button = Button.new(
    "Menu",
    function () game:changeState("menu") end,
    bx, by, buttonWidth, buttonHeight
    )
   button:setSound("blipdown")
   table.insert(self.buttons, button)

    self.text = "CREATED:\nRyan Rich\n\n"
    self.text = self.text .. "TOOLS:\n"
    self.text = self.text .. "Love2D - Game Platform (love2d.org)\n"
    self.text = self.text .. "Visual Studio Code - Source Code (code.visualstudio.com)\n"
    self.text = self.text .. "GIT - Source Code Control (git-scm.com)\n"
    self.text = self.text .. "GITHub - Repositry and Distribution (github.com)\n"
    self.text = self.text .. "BFXR - Sound Effects (bfxr.net)\n"
    self.text = self.text .. "SunVox - Music (warmplace.ru/soft/sunvox)\n"
    self.text = self.text .. "Inkscape - Graphics (inkscape.org)\n\n"
    self.text = self.text .. "MUSIC:\nSlavonic Dance #7, Op. 46, Antonín Dvorák"

    self.font = love.graphics.newFont(wh*0.05)

    local scale = self.font:getWidth(self.text)/ww
    if scale > 1.0 then
        self.font = love.graphics.newFont(wh*0.05/scale*0.9)
    end
end

function credits:draw()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    love.graphics.setColor(unpack(self.BGColor))

    love.graphics.rectangle("fill",0,0,ww, wh)

    for i, button in ipairs(self.buttons) do
        button:draw()
    end

    love.graphics.setColor(unpack(self.textColor))

    local tw = self.font.getWidth(self.font, self.text)
    local tx = (ww - tw) * 0.5
    local ty = wh * 0.1

    love.graphics.print(self.text,  self.font,tx, ty)
end

function credits:mousepressed(mx, my, button, istouch)

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

function credits:update(dt)
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

return credits