local gameOver = {
    isHighScore = false

}

--Check if the score is eligable for a high Score
function gameOver:entered()
    isHighScore = game.states.scoreboard:isHighScore(game.states.play:getTimeScore())
    love.graphics.setColor(1,1,1,1)
end

function gameOver:draw()
    love.graphics.print("Game Over Screen. Press Space to continue. Press Escape to go to Menu")
    if isHighScore == true then
        love.graphics.print("This is a high score!", 0, 20)
    else
        love.graphics.print("This is NOT a high score.", 0, 40)
    end
end


function gameOver:keypressed(key)
    if key == "space" then
        if isHighScore == true then
            game:changeState ("enterName")
        else
            game:changeState ("scoreboard")
        end
    end
    if key == "escape" then
        game:changeState("menu")
    end
end

return gameOver