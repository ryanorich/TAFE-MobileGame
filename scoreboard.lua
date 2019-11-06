local Button = require("button")


local scoreboard = {

ScoreboardFileName = "scores.txt",
scoreLimit = 10,
scores = {},
theScores = {},
BGColor = {0,0.2,0,1.0},
buttons = {}
}

--Deletes all current scores
function scoreboard:clearScores()
    local scoreboardFile = love.filesystem.newFile(self.ScoreboardFileName)
    scoreboardFile:open("w")
    scoreboardFile:close()
end

--Load scores from file
function scoreboard:loadScores()
    self.theScores = {}
    if love.filesystem.getInfo(self.ScoreboardFileName) then
        for scoreLine in love.filesystem.lines(self.ScoreboardFileName) do
 
            local scoreValue = tonumber(string.match(scoreLine, "^%d+%.%d+"))
            local scoreName = string.match(scoreLine, "%s(.+)$")
            if scoreName == nil then scoreName = " " end
            table.insert(self.theScores, {score=scoreValue, name=scoreName} )
            --self.loadAScore(score)
        end
        return true
    else
        return false
    end
end

--Adds a new score to the socres
function scoreboard:addScore(newScore, newName)
    local scores = {}
    if love.filesystem.getInfo(self.ScoreboardFileName) then
        for scoreLine in love.filesystem.lines(self.ScoreboardFileName) do
            local scoreValue = tonumber(string.match(scoreLine, "^%d+%.%d+"))
            local scoreName = string.match(scoreLine, "%s(.+)$")
            table.insert(scores, {score=scoreValue, name=scoreName} )
        end
    end

    table.insert(scores, {score=newScore, name=newName} )
    table.sort(scores, function (a, b) return a.score > b.score end)
    while #scores > self.scoreLimit do
        --Removes element from the end of the array
        table.remove(scores)
    end

    local scoreboardFile = love.filesystem.newFile(self.ScoreboardFileName)
    scoreboardFile:open("w")

    for i, score in ipairs(scores) do
        if score.name == nil then score.name = " " end
        scoreboardFile:write(score.score.." "..score.name.."\n")
    end

    scoreboardFile:close() 
end

--Determines if a score is OK to be added to the high scores
function scoreboard:isHighScore()
    scoreboard:isHighScore(self.playerScore)
end

--Determines if a score is OK to be added to the high scores
function scoreboard:isHighScore(scoreTime)
    --Load the scores, and ensure that they are valid
    if scoreboard:loadScores() == false then 
        print("No scoreboard error")
        return false 
    end

    --If the scoreboard is not filled up, then every score is a highscoree
    if #self.theScores < self.scoreLimit then
        print("There is room to add score")
        return true
    end

    --Otherwise, determine the low score
    local lowScore = nil
    print("Doing Scores")
    for i, score in ipairs(self.theScores) do
        local s = tonumber(string.match(score.score, "^%d+%.%d+"))
        print ("Match is :"..s)

        if lowScore == nil then
            lowScore = s
        elseif lowScore > s then
            lowScore = s
        end
        print ("Low Score is :"..lowScore)
    end

    --If the new score is greater than the low score, then can include
    if scoreTime > lowScore then
        return true
    else
        return false 
    end
end

--Adds a new score value to local vaiable
--TODO - Remove this
function scoreboard:addPlayerScore(score)
    self.playerScore = score
end

--TODO - Remove this - not used
function scoreboard:addPlayerName(name)
    self.playerName = name
end

--Load scores
function scoreboard:entered()
    self.buttons = {}


    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    local buttonWidth = ww * 0.4
    local buttonHeight = wh * 0.1

    local bx = (ww - buttonWidth) * 0.5
    local by = wh - buttonHeight * 1.5

    Button.setColors( {0.3, 0.4, 0.3, 1.0}, {0.7, 0.9, 0.5, 1.0}, {0,0.2,0,1.0} )

    --Button #1 - BACK TO Menu
    table.insert(self.buttons, Button.new(
        "1. Menu",
        function () game:changeState("menu") end,
        bx, by, buttonWidth, buttonHeight
    ))


  
    self:loadScores()
    print("Scoreboard Entered")


end

function scoreboard:update(dt)
    mx, my = love.mouse.getPosition()
    for i, button in ipairs(self.buttons) do
        if button:isInside(mx, my) then
            button.isHot = true
        else
            button.isHot = false
        end
    end
end

function scoreboard:mousepressed(mx, my, button, istouch)

    for i, button in ipairs(self.buttons) do
        if button:isInside(mx, my) then
            button:fn()
            break
        end
    end
end

function scoreboard:draw()
    love.graphics.setColor(unpack(self.BGColor))
    love.graphics.rectangle('fill',
            0,0,love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1,1,1,1)
    love.graphics.print("This is the scoreboard menu. There are "..#self.theScores.." scores recored:")

    for i, score in ipairs(self.theScores) do
        love.graphics.print(i..". \t"..score.score.." - "..score.name, 0, 20*i+20)
    end

    for i, button in ipairs(self.buttons) do
        button:draw()
    end
end


function scoreboard:keypressed(key)
    if  key == "escape" then
        game:changeState("menu")
    end
end

function scoreboard:update(dt)
    mx, my = love.mouse.getPosition()
    for i, button in ipairs(self.buttons) do
        if button:isInside(mx, my) then
            button.isHot = true
        else
            button.isHot = false
        end
    end
end

return scoreboard