local button = {
 COLOR = {073, 0.4, 0.3, 1.0},
 COLOR_HOT = {0.7, 0.9, 0.5, 1.0},
 COLOR_TEXT = {0.7,0,0,1.0} ,
 FONT = love.graphics.newFont(love.graphics.getHeight()*0.05),
}

function button.setColors(color, colorHot, colorText)
    button.COLOR = color
    button.COLOR_HOT = colorHot
    button.COLOR_TEXT = colorText
end

function button.new(text, fn, x, y, width, height)
    local self = {
        sound = {
            press = love.audio.newSource("sfx/blip.wav", "static"),
            hot = love.audio.newSource("sfx/hot.wav", "static"),
               },
    }
    self.text = text
    self.fn = fn   
    self.x = x
    self.y = y
    self.width = width
    self.height = height


    local x2 = self.x + width
    local y2 = self.y + height
    
    self.font = button.FONT
    local color = button.COLOR
    local colorHot = button.COLOR_HOT
    local colorText = button.COLOR_TEXT

    local textWidth = self.font.getWidth(self.font, self.text)
    local textHeight = self.font.getHeight(self.font, self.text)
    local tx = self.x + (self.width - textWidth) * 0.5
    local ty = self.y + (self.height - textHeight) * 0.5

    self.isHot = false

    function self:isInside(px, py)
        if px>=self.x and py>=self.y and px<=x2 and py <=y2 then
            return true
        else
            return false
        end
    end

    function self:draw()
        if self.isHot == true then
            love.graphics.setColor(colorHot)
        else
            love.graphics.setColor(color)
        end
        love.graphics.rectangle("fill", self.x, self.y, width, height)
        love.graphics.setColor(colorText)
        love.graphics.print(self.text, self.font, tx, ty)
    end
    
    function self:changeText(newText)
        self.text = newText
    end

    function self:playPressed()
        self.sound.press:play()
    end
    
    function self:playHot()
        self.sound.hot:play()
    end

    function self:setSound(sound)
        if sound == "blip" then
            self.sound.press = love.audio.newSource("sfx/blip.wav", "static")
        elseif sound == "blipup" then
            self.sound.press = love.audio.newSource("sfx/blipup.wav", "static")
        elseif sound == "blipdown" then
            self.sound.press = love.audio.newSource("sfx/blipdown.wav", "static")
        elseif sound == "klack" then
            self.sound.press = love.audio.newSource("sfx/blip.wav", "static")
        else
            self.sound.press = love.audio.newSource("sfx/blip.wav", "static")
        end

    end

    return self
end

return button