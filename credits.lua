local Button = require("button")

local credits = {
    buttons = {},
    BGColor = {0,0.2,0,1.0}

}

function credits:keypressed(key)
    if key == "escape" then
        game:changeState("menu")
    end
end

function credits:entered()
    self.buttons = {}
    Button.setColors( {0.3, 0.4, 0.3, 1.0}, {0.7, 0.9, 0.5, 1.0}, {0,0.2,0,1.0} )

    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    local buttonWidth = ww * 0.4
    local buttonHeight = wh * 0.1

    local bx = (ww - buttonWidth) * 0.5
    local by = wh - buttonHeight * 1.5

   --Button #1 - BACK TO Menu
   table.insert(self.buttons, Button.new(
    "Menu",
    function () game:changeState("menu") end,
    bx, by, buttonWidth, buttonHeight
    ))

end

function credits:draw()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    love.graphics.setColor(unpack(self.BGColor))

    love.graphics.rectangle("fill",0,0,ww, wh)

    for i, button in ipairs(self.buttons) do
        button:draw()
    end

end

function credits:mousepressed(mx, my, button, istouch)

    for i, button in ipairs(self.buttons) do
        if button:isInside(mx, my) then
            button.fn()
            break
        end
    end
end

function credits:update(dt)
    mx, my = love.mouse.getPosition()
    for i, button in ipairs(self.buttons) do
        if button:isInside(mx, my) then
            button.isHot = true
        else
            button.isHot = false
        end
    end
end


return credits