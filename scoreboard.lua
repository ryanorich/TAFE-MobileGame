local scoreboard = {

ScoreboardFileName = "scores.txt",
scoreLimit = 2,
scores = {},
playerScore = 0,

timeScores = {}

}


function scoreboard:clearScores()
    local scoreboardFile = love.filesystem.newFile(self.ScoreboardFileName)
    scoreboardFile:open("w")
    scoreboardFile:close()
end

function scoreboard:loadScores()
    self.scores = {}

    if love.filesystem.getInfo(self.ScoreboardFileName) then
        for score in love.filesystem.lines(self.ScoreboardFileName) do
            table.insert(self.scores, score)
        end
        return true
    else
        table.insert(self.scores, "No score data...")
        return false
    end
end

function scoreboard:addScore(score)
    local scores = {}
    if love.filesystem.getIfo(self.ScoreboardFileName) then
        for score in love.filesystem.lines(self.ScoreboardFileName) do
            table.insert(scores, score)
        end
    end

    table.insert(scores, score)

    table.sort(scores, function(a, b) return a > b end)

    while #scores > self.scoreLimit do
        --Removes element from the end of the array
        table.remove(scores)
    end

    local scoreboardFile = love.filesystem.newFile(self.ScoreboardFileName)
    scoreboardFile:open("W")

    for i, score in ipairs(scores) do
        scoreboardFile:write(score .. "\n")
    end

    scoreboardFile:close()
end

function scoreboard:isHighScore(scoreTime)
    --Load the scores, and ensure that they are valid
    if scoreboard:loadScores() == false then 
        print("No scoreboard error")
        return false 
    
    end

    --If the scoreboard is not filled up, then every score is a highscoree
    if #self.scores < self.scoreLimit then
        print("There is room to add score")
        return true

    end

    --Otherwise, determine the low score
    local lowScore = nil
    print("Doing Scores")
    for i, scoreLine in ipairs(self.scores) do
        print("ScoreLine:"..scoreLine)
        
        local s = tonumber(string.match(scoreLine, "^%d+%.%d+"))
        print ("Match is :"..s)
        
        table.insert(self.timeScores, s)
        local count = #self.timeScores
        print("Table Size: "..count)

        if lowScore == nil then
            lowScore = s
        elseif lowScore > s then
            lowScore = s
        end
        print ("Low Score is :"..lowScore)
    end

    --If the new score is greater than the low score, then can include
    if self.playerScore > lowScore then
        print("Score is good enough for highscore")
        return true
        
    else
        print("Score is not good enough")
        return false
        
    end
   

end


function scoreboard:addPlayerScore(score)
    self.playerScore = score
end

function scoreboard:entered()
    drawDisplay = false
    print("Scoreboard Entered")
    local hs = self:isHighScore()

    if hs == true then 
        table.insert(self.scores, 
                string.format("%.3f",self.playerScore).."\t"..
                string.format("%-50s","Name Here") .. 
                os.date("%Y-%m-%d_%H:%M:%S") )

    else
        table.insert(self.scores, "Not high Score")
            end


end

function scoreboard:draw()
    if drawDisplay == false then
        print("First Draw Entered")
        drawDisplay = true
    end

    love.graphics.setColor(1,1,1,1)

    love.graphics.print("This is the scoreboard menu. "..#self.timeScores)

    for i, score in ipairs(self.scores) do
        love.graphics.print(score, 0, 20*i)
    end
end

function scoreboard:keypressed(key)
    if key == "space" or key == "escape" then
        game:changeState("menu")
    end
end

return scoreboard