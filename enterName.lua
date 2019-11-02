local enterName = {

    name = "",
    MAX_LENGTH = 30
}

function enterName:entered()
    self.name = ""
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
    elseif key == "backspace" then
        self.name = string.sub(self.name, 1, -2)
    
    elseif string.len(key) == 1  and string.find(key, "%w") ~= nill then
        --adding letter. 
        if string.len(self.name) < self.MAX_LENGTH then
            self.name = self.name..string.upper(key)
        end
    elseif string.len(key) == 1  and string.find(key, "[%d%p]") then
        --adding punctuation
        if string.len(self.name) < self.MAX_LENGTH then
            self.name = self.name..key
        end
    end

end

function enterName:draw()
    love.graphics.print("Enter in a name here, and press Enter:")
    love.graphics.print(self.name, 0, 20)

end

return enterName