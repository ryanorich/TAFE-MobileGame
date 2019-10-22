local missile  = {}

function missile.new(source, tx, ty)
    local self = {}

    self.source = source
    self.targetx = tx
    self.targety = ty
    self.alive = true

    function self:update(dt)
        if self.alive then
            --play:addBlast(targetx, targety)
            self.alive = false
        end
    end
    

    function self:draw()

    end

    return self
end

return missile