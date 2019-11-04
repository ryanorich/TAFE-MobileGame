local button = {

 COLOR = {073, 0.4, 0.3, 1.0},
 COLOR_HOT = {0.7, 0.9, 0.5, 1.0},
 COLOR_TEXT = {0.7,0,0,1.0} ,
 FONT = nil
}

button.FONT = love.graphics.newFont(love.graphics.getHeight()*0.05)

--print("Font is ".. button.FONT)
function button.setColors(color, colorHot, colorText)
    button.COLOR = color
    button.COLOR_HOT = colorHot
    button.COLOR_TEXT = colorText
end

function button.new(text, fn, x, y, width, height)
    local self = {}
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
    

    
    return self
end

return button