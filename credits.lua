local credits = {

}

function credits:keypressed(key)
    if key == "escape" then
        game:changeState("menu")
    end
end

function credits:draw()
    love.graphics.print("This is the Credits screen. Press Excape to retunr to manu.")
end


return credits