local Button = require("button")

local scoreboard = {

ScoreboardFileName = "scores.txt",
scoreLimit = 10,
scores = {},
theScores = {},
BGColor = {0,0.2,0,1.0},
textColor = {0.5,0.9,0.4,1.0},
buttons = {},

font = love.graphics.newFont(love.graphics.getHeight()*0.05)
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
        return false 
    end

    --If the scoreboard is not filled up, then every score is a highscoree
    if #self.theScores < self.scoreLimit then
        return true
    end

    --Otherwise, determine the low score
    local lowScore = nil
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

--Load scores
function scoreboard:entered()
    self.buttons = {}

    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    local buttonWidth = ww * 0.4
    local buttonHeight = wh * 0.1

    local bx = (ww - buttonWidth) * 0.5
    local by = wh - buttonHeight * 1.5

    Button.setColors( {0.4, 0.5, 0.3, 1.0}, {0.8, 0.9, 0.5, 1.0}, {0,0.2,0,1.0} )

    --Button #1 - BACK TO Menu
    button = Button.new(
        "Menu",
        function () game:changeState("menu") end,
        bx, by, buttonWidth, buttonHeight
    )
    button:setSound("blipdown")
    table.insert(self.buttons, button )

    self:loadScores()
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
            if game.states.settings.soundOn then
                button:playPressed()
            end
            button:fn()
            break
        end
    end
end

function scoreboard:draw()
    love.graphics.setColor(unpack(self.BGColor))
    love.graphics.rectangle('fill',
            0,0,love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(unpack(self.textColor))

    ww, wh = love.graphics.getDimensions()
    tx1 = ww*0.05
    tx2 = ww*0.15
    tx3 = ww*0.3
    ty = wh*0.1
    tspacing = wh*0.7  /10.0

    for i, score in ipairs(self.theScores) do
        love.graphics.print(i..".", self.font, tx1, ty + tspacing * (i-1))
        love.graphics.print(score.score, self.font, tx2, ty + tspacing * (i-1))
        love.graphics.print(score.name, self.font, tx3, ty + tspacing * (i-1))
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
            if button.isHot == false then
                button.isHot = true
                if game.states.settings.soundOn then
                    button:playHot()
                end
            end
        else
            button.isHot = false
        end
    end
end

return scoreboard