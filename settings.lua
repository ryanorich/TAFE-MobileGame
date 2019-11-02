
local settings = {


}

function settings:keypressed(key)

    if key == "escape" then
        game:changeState( "menu" )
    end
end

function settings:draw()
    love.graphics.print("The Settings Manu. Press Excape to return to manu")
end

return settings