--Table to sore the game state
game = {
current_state = "menu",
    states = {
        menu =          require("menu"),
        play =          require("play"),
        scoreboard =    require("scoreboard"),
        settings =      require("settings"),
        enterName =     require("enterName"),
        gameOver =      require("gameOver"),
        credits =       require("credits")
    },

    functions = {
        "draw",
        "keypressed",
        "mousepressed",
        "update"
    }
}

--This generates the boilerplate code require for states stored in game.
function game:linkEvent(event)
    love[event] = function(...)
        if      self.states[self.current_state] ~= nil then
            if    self.states[self.current_state][event] ~= nil then
                self.states[self.current_state][event](self.states[self.current_state], ...)
            end
        end
    end
end

--Callback for changing states
function game:changeState(state)
    if      self.states[state] ~= nil then
        if  self.states[self.current_state].exited ~= nil then
            self.states[self.current_state].exited(self.states[self.current_state])
        end

        self.current_state = state

        if self.states[self.current_state].entered ~= nil then
            self.states[self.current_state].entered(self.states[self.current_state])
        end
    end
end

--Creating linking functions
for i, fun in ipairs(game.functions) do
    game:linkEvent(fun)
end

--Make sure that the Entered state of the menu is entered.
game:changeState("menu")



