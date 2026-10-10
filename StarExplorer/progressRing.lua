-- progressRing Module for Corona SDK
-- Copyright (c) 2014 Jason Schroeder
-- http://www.jasonschroeder.com
-- http://www.twitter.com/schroederapps

--[[ Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE. ]]--

------------------------------------------------------------------------------------
-- CREATE TABLE TO HOLD MODULE
------------------------------------------------------------------------------------
local progressRing = {}

------------------------------------------------------------------------------------
-- SCREEN POSITIONING VARIABLES
------------------------------------------------------------------------------------
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenTop = display.screenOriginY
local screenLeft = display.screenOriginX
local screenBottom = display.screenOriginY+display.actualContentHeight
local screenRight = display.screenOriginX+display.actualContentWidth
local screenWidth = screenRight - screenLeft
local screenHeight = screenBottom - screenTop

------------------------------------------------------------------------------------
-- CREATE NEW PROGRESS RING
------------------------------------------------------------------------------------
function progressRing.new(params)
    -- available params are: radius, ringColor, bgColor, strokeColor, ringDepth, strokeWidth, hideBG, time, position, topImage, bottomImage
    if params == nil then params = {} end

    --------------------------------------------------------------------------------
    -- LOCALIZE PARAMS & SET DEFAULTS
    --------------------------------------------------------------------------------
    local radius = params.radius or 100
    local counterclockwise = params.counterclockwise
    local ringColor = params.ringColor or {1, 1, 1}
    local bgColor = params.bgColor or {0, 0, 0}
    local strokeColor = params.strokeColor or bgColor
    local ringDepth = params.ringDepth or .33
    local strokeWidth = params.strokeWidth or 0
    local hideBG = params.hideBG
    local time = params.time or 10000
    local startPosition = params.position or 0
    local topImage = params.topImage
    local bottomImage = params.bottomImage
    local x = params.x or 0
    local y = params.y or 0
    local size = params.size or 1
    
    if ringDepth > 1 then ringDepth = 1 elseif ringDepth <0 then ringDepth = 0 end

    --------------------------------------------------------------------------------
    -- CREATE PROGRESS RING VISUALS
    --------------------------------------------------------------------------------
    local group = display.newGroup()
    group.position = startPosition
    group.x = x
    group.y = y
    group:scale(size, size)
    
    local objectName = tostring(group)
    if counterclockwise == true then group.xScale = -1 end
    local sliceGroup = display.newGroup()
    sliceGroup.group = sliceGroup
    function sliceGroup.invalidate() end
    if ringColor[4] ~= nil and ringColor[4] < 1 and ringColor[4] > 0 then
        sliceGroup = nil
        sliceGroup = display.newSnapshot(radius*2, radius*2)
        sliceGroup.alpha = ringColor[4]
    end
    local sliceContainer = display.newContainer(group, radius*2, radius*2)
    sliceContainer.anchorChildren = false
    sliceContainer.anchorX = 0
    group.isVisible = false

    local slices = {}

    local bg = display.newCircle(group, 0, 0, radius)
    bg:setFillColor(unpack(bgColor))
    group:insert(sliceGroup)
    if hideBG then bg.isVisible = false end
    local stroke1 = display.newCircle(group, 0, 0, radius + strokeWidth*.5)
    stroke1:setFillColor(0, 0, 0, 0)
    stroke1:setStrokeColor(unpack(strokeColor))
    stroke1.strokeWidth = strokeWidth
    local stroke2 = display.newCircle(group, 0, 0, radius - radius*ringDepth - strokeWidth/2)
    stroke2:setFillColor(0, 0, 0, 0)
    stroke2:setStrokeColor(unpack(strokeColor))
    stroke2.strokeWidth = strokeWidth

    if bottomImage ~= nil then
        local getDims = display.newImage(bottomImage)
        getDims.isVisible = false
        local w, h = getDims.width, getDims.height
        group.bottomImage = display.newImageRect(bottomImage, w, h)
        group.bottomImage.x, group.bottomImage.y = 0, 0
        group:insert(1, group.bottomImage)
        display.remove(getDims)
        getDims = nil
    end

    if topImage ~= nil then
        local getDims = display.newImage(topImage)
        getDims.isVisible = false
        local w, h = getDims.width, getDims.height
        group.topImage = display.newImageRect(group, topImage, w, h)
        group.topImage.x, group.topImage.y = 0, 0
        display.remove(getDims)
        getDims = nil
    end

    --------------------------------------------------------------------------------
    -- ADD PROGRESS RING "SLICES"
    --------------------------------------------------------------------------------
    local sliceHeight = radius * 1.5
    for i = 0, 350, 10 do
        local slice = display.newPolygon(0, 0, {0, 0, 0, -sliceHeight, sliceHeight*.182, -sliceHeight})
        local ringColor = {ringColor[1], ringColor[2], ringColor[3]}
        slice:setFillColor(unpack(ringColor))
        slice.anchorX, slice.anchorY = 0, 1
        slice.target = i
        if i >=180 then
            sliceGroup.group:insert(slice)
        else
            sliceContainer:insert(slice)
        end
        slice.rotation = -10
        slices[#slices+1] = slice
    end

    --------------------------------------------------------------------------------
    -- CREATE CIRCULAR MASK FOR SLICES
    --------------------------------------------------------------------------------
    local stageColor = display.getDefault("background")
    local coverUp = display.newRect(centerX, centerY, screenWidth, screenHeight)
    coverUp:setFillColor(stageColor)
    display.getCurrentStage():insert(1, coverUp)

    local squareSize = screenWidth - 16
    if screenWidth > screenHeight then squareSize = screenHeight - 16 end
    squareSize = math.floor(squareSize*.25)*4 + 16
    local maskRadius = squareSize * .5 - 16
    local maskScaleX = radius / (maskRadius / display.contentScaleX)
    local maskScaleY = radius / (maskRadius / display.contentScaleY)

    local maskGroup = display.newGroup()
    maskGroup.x, maskGroup.y = centerX, centerY
    display.getCurrentStage():insert(1, maskGroup)
    local square = display.newRect(maskGroup, 0, 0, squareSize, squareSize)
    square:setFillColor(0)
    local circle = display.newCircle(maskGroup, 0, 0, maskRadius)
    circle:setFillColor(1)
    local circle2 = display.newCircle(maskGroup, 0, 0, maskRadius*(1-ringDepth))
    circle2:setFillColor(0)
    timer.performWithDelay(10, function()
        local maskImage = display.capture(maskGroup, { saveToPhotoLibrary=false, isFullResolution=false } )
        display.getCurrentStage():insert(1, maskImage)

        timer.performWithDelay(1, function()
            display.save( maskImage, {filename=objectName..".jpg", baseDir=system.TemporaryDirectory, isFullResolution=true} )
            local mask = graphics.newMask( objectName..".jpg", system.TemporaryDirectory )

            timer.performWithDelay(1, function()
                bg:setMask(mask)
                bg.maskScaleX, bg.maskScaleY = maskScaleX, maskScaleY
                sliceGroup.group:setMask(mask)
                sliceGroup.maskScaleX, sliceGroup.maskScaleY = maskScaleX, maskScaleY
                display.remove(maskGroup)
                display.remove(maskImage)
                display.remove(coverUp)
                sliceGroup.group:insert(sliceContainer)
                group.isCreated = true
                group:goTo(startPosition, 0, true)
                group.isVisible = true
            end)
        end)
    end)

    --------------------------------------------------------------------------------
    -- SET RING POSITION (i.e. start rotation)
    --------------------------------------------------------------------------------
    function group.goTo(self, position, customTime, doNotDispatch)
        if group.isCreated then
            transition.cancel(objectName)
            local newPosition = position
            if newPosition >= 100 then newPosition = 99.999999999 end
            if newPosition < 0 then newPosition = 0 end
            local newRotation = 359.9999 * (newPosition*.01)
            if customTime == nil then customTime = time*.01*math.abs(newPosition-self.position) end
            if customTime > 0 then
                transition.to(self, {rotation=newRotation, time=customTime, transition=easing.linear, iterations=1, tag=objectName, onComplete=function()
                    if doNotDispatch ~= true then
                        group:dispatchEvent({name="onRingComplete", target=group})
                    end
                end})
            else
                self.rotation = newRotation
                if doNotDispatch ~= true then
                    group:dispatchEvent({name="onRingComplete", target=group})
                end
            end
            self.position = newPosition
        end
    end

    --------------------------------------------------------------------------------
    -- START RING PROGRESS
    --------------------------------------------------------------------------------
    function group.start(self, customTime)
        if customTime == nil then customTime = time*(1-(group.position*.01)) end
        if customTime > 0 then
            transition.to(self, {rotation=359.9999, time=customTime, transition=easing.linear, iterations=1, tag=objectName, onComplete=function()
                group:dispatchEvent({name="onRingComplete", target=group})
            end})
        end
        self.position = 100
    end

    --------------------------------------------------------------------------------
    -- PAUSE RING PROGRESS
    --------------------------------------------------------------------------------
    function group.pause(self)
        transition.cancel(objectName)
    end

    --------------------------------------------------------------------------------
    -- RESUME RING PROGRESS
    --------------------------------------------------------------------------------
    function group.resume(self)
        local elapsed = group.position * .01 * time
        local remaining = time - elapsed
        group:start(remaining)
    end

    --------------------------------------------------------------------------------
    -- REMOVE RING PROGRESS
    --------------------------------------------------------------------------------
    function group.remove(self)
        transition.cancel(objectName)
        if sliceGroup.group.setMask then
            sliceGroup.group:setMask(nil)
        end
        if bg.setMask then
            bg:setMask(nil)
        end
        display.remove(group)
    end

    return group
end

return progressRing
