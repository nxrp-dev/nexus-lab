-- gamegui.lua
local gamegui = {}

local composer = require( "composer" )
local const = require("const")

local explosionSound
local fireSound

function Init()
    explosionSound = audio.loadSound( "audio/ScifiTactics/ButtonClick2.wav" )
    --explosionSound = audio.loadSound( "audio/mixkit-fast-sci-fi-bleep-903.wav" )
    
    fireSound = audio.loadSound( "audio/fire.wav" )	
    musicTrack = audio.loadStream( "audio/80s-Space-Game_Looping.wav")	
end
Init()

-- Function to display a console with a background and an overlay image
function gamegui.DisplayConsole(parentGroup, backgroundPath, overlayPath)
    -- Load and display the background image
    local background = display.newImageRect(parentGroup, "graphics/background/BG2.png", 1280, 720)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- Load and display the overlay image
    local overlay = display.newImageRect(parentGroup, "graphics/background/cardx5.png", 1280, 720)
    overlay.x = display.contentCenterX
    overlay.y = display.contentCenterY

    return {background = background}--, overlay = overlay}
end

function gamegui.DisplayInteractivePanel(parentGroup) 
    local screenWidth = display.contentWidth
    local screenHeight = display.contentHeight

    local lPanelGroup = display.newGroup(parentGroup)
    local childBox2 = display.newImageRect(lPanelGroup, "graphics/background/cardx2.png", (screenWidth * 0.25) - 25, (screenHeight * 0.5) - 25)
    --local childBox2 = display.newRect(parentGroup, 0, 0, screenWidth * 0.25, screenHeight * 0.5)
    childBox2.anchorX = 0
    childBox2.anchorY = 0
    childBox2.x = (screenWidth * 0.75) - 5
    childBox2.y = 35
    childBox2:setFillColor(0, 0, 1, 0.5)  -- Set semi-transparent green color for visibility
    return {
        PanelGroup = lPanelGroup,
        LocationX = childBox2.x,
        LocationY = childBox2.y
    }

end

local function ButtonClickTransition(AEvent)
    audio.play(explosionSound)
    transition.to(AEvent.target.Group, { xScale=1.05, yScale=1.05, time=150, onComplete = function() transition.to(AEvent.target.Group, { xScale=1.0, yScale=1.0, time=150 } ) end })
end

local function ButtonClickScene(AEvent) 
    composer.gotoScene( "scenes."..AEvent.target.Scene, { time=800, effect="crossFade" } )
end

local function ButtonClickCutScene(AEvent) 
    local lScene = composer.loadScene("scenes.cutscene")
    lScene.CutName = AEvent.target.Scene
    print(AEvent.target)
    composer.gotoScene("scenes.cutscene")
end

function gamegui.DrawButton(AView, ACaption, ATop, ALeft, AOnClick) 
    local lButtonGroup = display.newGroup(AView)
    AView:insert(lButtonGroup)
--    lButton = display.newImage(lButtonGroup, "graphics/Main_Menu/EmptyButton.png", ATop, ALeft)
    lButton = display.newImageRect(lButtonGroup, "graphics/hologram/Button 1/Button Normal.png", 185, 50)--ATop, ALeft)
    
    lButton.anchorX = 0
    lButton.anchorY = 0
    lButton.x = ALeft
    lButton.y = ATop
    lButton:setFillColor(0, .5, .5, 0.5)  -- Set semi-transparent green color for visibility

	local lDisplayText = display.newText(lButtonGroup, ACaption, ALeft+(lButton.width * 0.5), ATop+(lButton.height * 0.5), const.cGameFont, 24 )

    lButton.Caption = lDisplayText
    lButton.Group = lButtonGroup
    lButton:addEventListener("tap", ButtonClickTransition)
    lButton:addEventListener("tap", AOnClick)
    return lButton
end

function gamegui.DrawPanel(AView, ACaption, ATop, ALeft, AWidth, AHeight) 
    local lButtonGroup = display.newGroup(AView)
    AView:insert(lButtonGroup)
--    lButton = display.newImage(lButtonGroup, "graphics/Main_Menu/EmptyButton.png", ATop, ALeft)
    lButton = display.newImageRect(lButtonGroup, "graphics/hologram/button 1/button normal.png", 185, 50)--ATop, ALeft)
    
    lButton.anchorX = 0
    lButton.anchorY = 0
    lButton.x = ALeft
    lButton.y = ATop
    lButton:setFillColor(0, .5, .5, 0.5)  -- Set semi-transparent green color for visibility

	local lDisplayText = display.newText(lButtonGroup, ACaption, ALeft+(lButton.width * 0.5), ATop+(lButton.height * 0.5), "fonts/Elianto/Elianto-Regular.ttf", 24 )

    lButton.Caption = lDisplayText
    lButton.Group = lButtonGroup
    lButton:addEventListener("tap", ButtonClickTransition)
    lButton:addEventListener("tap", AOnClick)
    return lButton
end


function gamegui.DrawSceneButton(AView, ACaption, ATop, ALeft, AScene) 
    local lButton = gamegui.DrawButton(AView, ACaption, ATop, ALeft, ButtonClickScene)
    lButton.Scene = AScene;
--    lButton:addEventListener("tap", ButtonClickScene)
end

function gamegui.DrawCutSceneButton(AView, ACaption, ATop, ALeft, AScene) 
    local lButton = gamegui.DrawButton(AView, ACaption, ATop, ALeft, ButtonClickCutScene)
    lButton.Scene = AScene;
--    lButton:addEventListener("tap", ButtonClickCutScene)
end

function gamegui.ShowModalDialog()
    -- Create a group for the modal dialog
    local modalGroup = display.newGroup()

    -- Create a semi-transparent background
    local background = display.newRect(modalGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    background:setFillColor(0, 0, 0, 0.5)  -- Semi-transparent black

    -- Prevent touch events from passing through the background
    background:addEventListener("touch", function() return true end)
    background:addEventListener("tap", function() return true end)

    -- Create the dialog box
    local dialogBox = display.newRoundedRect(modalGroup, display.contentCenterX, display.contentCenterY, 300, 200, 12)
    dialogBox:setFillColor(1)  -- White

    -- Add text to the dialog box
    local dialogText = display.newText({
        parent = modalGroup,
        text = "This is a modal dialog box.",
        x = display.contentCenterX,
        y = display.contentCenterY - 30,
        width = 280,
        font = native.systemFont,
        fontSize = 18,
        align = "center"
    })
    dialogText:setFillColor(0)  -- Black text

    -- Add a close button
    local closeButton = display.newText({
        parent = modalGroup,
        text = "Close",
        x = display.contentCenterX,
        y = display.contentCenterY + 50,
        width = 280,
        font = native.systemFontBold,
        fontSize = 18,
        align = "center"
    })
    closeButton:setFillColor(0.8, 0, 0)  -- Red button text

    -- Close button event listener
    local function onCloseButtonTap(event)
        modalGroup:removeSelf()
        modalGroup = nil
    end
    closeButton:addEventListener("tap", onCloseButtonTap)
end

local function makeZoomable(dragGroup, container)
    local function onTouch(event)
        local phase = event.phase
        local target = event.target

        if phase == "began" then
            display.getCurrentStage():setFocus(target)
            target.isFocus = true

            -- Store initial touch position and group's position
            target.touchOffsetX = event.x - target.x
            target.touchOffsetY = event.y - target.y
            target.initialScale = target.xScale

            if event.numTouches == 2 then
                -- Calculate the initial distance between the two touches
                local dx = event.x - event.xStart
                local dy = event.y - event.yStart
                target.initialDistance = math.sqrt(dx * dx + dy * dy)
            end

        elseif target.isFocus then
            if event.numTouches == 2 then
                if phase == "moved" then
                    -- Calculate the new distance between the two touches
                    local dx = event.x - event.xStart
                    local dy = event.y - event.yStart
                    local newDistance = math.sqrt(dx * dx + dy * dy)

                    -- Calculate the scale factor
                    local scale = newDistance / target.initialDistance
                    target.xScale = target.initialScale * scale
                    target.yScale = target.initialScale * scale

                    -- Apply constraints to keep the group within container bounds
                    target.xScale = math.max(0.5, math.min(target.xScale, 2))
                    target.yScale = target.xScale

                elseif phase == "ended" or phase == "cancelled" then
                    display.getCurrentStage():setFocus(nil)
                    target.isFocus = nil
                end

            elseif event.numTouches == 1 then
                if phase == "moved" then
                    -- Calculate the new position
                    local newX = event.x - target.touchOffsetX
                    local newY = event.y - target.touchOffsetY

                    -- Apply constraints to ensure the group stays within the container
                    newX = math.max(container.x, math.min(newX, container.x + container.width - target.width * target.xScale))
                    newY = math.max(container.y, math.min(newY, container.y + container.height - target.height * target.yScale))

                    -- Move the group to the new position
                    target.x = newX
                    target.y = newY

                elseif phase == "ended" or phase == "cancelled" then
                    display.getCurrentStage():setFocus(nil)
                    target.isFocus = nil
                end
            end
        end

        return true
    end

    dragGroup:addEventListener("touch", onTouch)
end

local function makeDraggable(dragGroup, container)
    -- Ensure anchor points are set to 0
    dragGroup.anchorX = 0
    dragGroup.anchorY = 0

    local startX, startY
    local offsetX, offsetY

    local function onTouch(event)
        local phase = event.phase

        if phase == "began" then
            display.getCurrentStage():setFocus(event.target)
            event.target.isFocus = true

            -- Store initial touch position and group position
            startX = event.x
            startY = event.y
            offsetX = dragGroup.x
            offsetY = dragGroup.y

        elseif event.target.isFocus then
            if phase == "moved" then
                -- Calculate new position
                local newX = offsetX + (event.x - startX)
                local newY = offsetY + (event.y - startY)

                -- Clamp new position within the bounds of the container
                newX = math.max(container.x - (dragGroup.width - container.width), math.min(container.x, newX))
                newY = math.max(container.y - (dragGroup.height - container.height), math.min(container.y, newY))

                -- Apply new position
                dragGroup.x = newX
                dragGroup.y = newY

            elseif phase == "ended" or phase == "cancelled" then
                display.getCurrentStage():setFocus(nil)
                event.target.isFocus = nil
            end
        end

        return true
    end

    dragGroup:addEventListener("touch", onTouch)
end

-- basically a container panel but built around the metrics of a tracked grid
function gamegui.newMapPanel(AParentGroup, x, y, AWidth, AHeight, ATileSize, ATileWidth, ATileHeight, AImage)
    local lGroup = gamegui.newPanel(AParentGroup, x, y, AWidth, AHeight)

    local lContainer = display.newContainer(lGroup, AWidth * 0.93, AHeight * 0.92)
    lContainer:translate(AWidth * .5, AHeight * .5)
    lGroup:insert(lContainer)  

    -- Create the starmap group
    local lBackgroundGroup = display.newGroup()
	local lBackground = display.newImageRect(lBackgroundGroup, AImage, ATileSize*ATileWidth*2, ATileSize*ATileHeight*2)

    lGroup:insert(lContainer)
	lBackgroundGroup:insert(lBackground)
    lContainer:insert(lBackgroundGroup)

    makeZoomable(lBackgroundGroup, lContainer)
    makeDraggable(lBackgroundGroup, lContainer)

    return lBackgroundGroup
end

-- puts a container inside a panel with a scrollable background image.
function gamegui.newContainerPanel(AParentGroup, x, y, AWidth, AHeight, ABackgroundImage)
    local lGroup = gamegui.newPanel(AParentGroup, x, y, AWidth, AHeight)

    local lContainer = display.newContainer(lGroup, AWidth * 0.9, AHeight * 0.9)
    lContainer:translate(AWidth * 0.5, AHeight * 0.5)
    lGroup:insert(lContainer)  

    -- Create the starmap group
    local lBackgroundGroup = display.newGroup()
    -- need to get sizes right, for now this will do for testing.
	local lBackground = display.newImageRect(lBackgroundGroup, ABackgroundImage, AWidth * 4, AHeight * 4)
	lBackground.x = 0
	lBackground.y = 0
    lGroup:insert(lContainer)
	lBackgroundGroup:insert(lBackground)
    lContainer:insert(lBackgroundGroup)
--
    makeDraggable(lBackgroundGroup, lContainer)

    local function onZoom(event)
--        local scale = starmap.xScale + (event.delta / 100)
  --      if scale > 0.5 and scale < 2 then
    --        starmap:scale(scale / starmap.xScale, scale / starmap.xScale)
      --  end
    end

    return lBackgroundGroup
end

function gamegui.newTextPanel(AParentGroup, x, y, AWidth, AHeight)
    local lGroup = gamegui.newPanel(AParentGroup, x, y, AWidth, AHeight)

    local options = {
        parent = lGroup,
		text = "",
		x = AWidth * 0.050,
		y = AHeight * 0.050,
		width = AWidth * 0.9,
		font = "fonts/Elianto/Elianto-Regular.ttf", -- Choose your font
		fontSize = 32, 
		align = "left", 
        height = AHeight * 0.9
	}

	-- Create the text object
	local lText = display.newText(options)
    lText.anchorX = 0
    lText.anchorY = 0
    lText.x = AWidth * 0.050
    lText.y = AHeight * 0.10
    lText.height = AHeight * 0.8
    lText.width = AWidth * 0.9

    lText:setFillColor(1, 1, 1)
	AParentGroup:insert(lGroup)
    lGroup.Text = lText
    -- not correct, but we are not shooting for 100%
    AParentGroup.QuestionLabel = lText
    return lGroup
end

function gamegui.newPortrait(parentGroup, x, y, width, height, image)
    local lGroup = gamegui.newPanel(parentGroup, x, y, width, height)

    local lPortrait = display.newImageRect(image, width * 0.8, height * 0.8)
    lPortrait.anchorX, lPortrait.anchorY = 0, 0
    lPortrait.x = width * 0.10
    lPortrait.y = height * 0.10

    lGroup:insert(lPortrait)
    return lGroup
end


local function newPanelElement(AParentGroup, AImageSheet, AFrameIndex, AWidth, AHeight, ALeft, ATop)
    local lElement = display.newImageRect(AParentGroup, AImageSheet, AFrameIndex, AWidth, AHeight)
    lElement.anchorX, lElement.anchorY = 0, 0
    lElement.x, lElement.y = ALeft, ATop
    --lElement:setFillColor(0, 0.914, 0.733, 0.75)
    return lElement;
end

-- panel.lua
function gamegui.newPanel(parentGroup, x, y, width, height)
    local panelGroup = display.newGroup()
--    local imageSheet = params.imageSheet
    local imageSheet = graphics.newImageSheet( "graphics/hologram/cardx2/cardx3.png", const.cPanelOptions)

    local panelGroup = display.newGroup()
    parentGroup:insert(panelGroup)
    panelGroup.x, panelGroup.y = x, y

    local topLeftFrame = const.cPanelOptions.frames[1]
    local cornerSize = topLeftFrame.width

    local topLeft = newPanelElement(panelGroup, imageSheet, 1, cornerSize, cornerSize, 0, 0)
    local topMiddle = newPanelElement(panelGroup, imageSheet, 2, width - 2 * cornerSize, cornerSize, cornerSize, 0)
    local topRight = newPanelElement(panelGroup, imageSheet, 3, cornerSize, cornerSize, width - cornerSize, 0)
    local leftMiddle = newPanelElement(panelGroup, imageSheet, 4, cornerSize, height - 2 * cornerSize, 0, cornerSize)
    local middle = newPanelElement(panelGroup, imageSheet, 5, width - 2 * cornerSize, height - 2 * cornerSize, cornerSize, cornerSize)
    local rightMiddle = newPanelElement(panelGroup, imageSheet, 6, cornerSize, height - 2 * cornerSize, width - cornerSize, cornerSize)
    local bottomLeft = newPanelElement(panelGroup, imageSheet, 7, cornerSize, cornerSize, 0, height - cornerSize)
    local bottomMiddle = newPanelElement(panelGroup, imageSheet, 8, width - 2 * cornerSize, cornerSize, cornerSize, height - cornerSize)
    local bottomRight = newPanelElement(panelGroup, imageSheet, 9, cornerSize, cornerSize, width - cornerSize, height - cornerSize)
    panelGroup:toFront()
    return panelGroup
end

return gamegui
