--Table to sore the game state
game = {
current_state = "menu",
    states = {
        menu = require("menu"),
        play = require("play")
    }
}

--This generates the boilerplate code require for states stored in game.
function game:link_event(event)
    love[event] = function(...)
        if      self.states[self.current_state] ~= nil then
            if    self.states[self.current_state][event] ~= nil then
                self.states[self.current_state][event](self.states[self.current_state], ...)
            end
        end
    end
end

--Callback for changing states

function game:change_state(state)
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

--Calling the linking functions.
game:link_event("draw")
game:link_event("keypressed")
game:link_event("mousepressed")
game:link_event("update")
