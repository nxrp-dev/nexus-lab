local composer = require( "composer" )
local gamegui = require("gamegui")
local scene = composer.newScene()
local npcdialog = require("npcdialog")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
function scene:DisplayInteractivePanel() 
    local screenWidth = display.contentWidth
    local screenHeight = display.contentHeight

    local lPanelGroup = display.newGroup(self.view)
	local test = display.newRoundedRect(lPanelGroup, 10, 10, (screenWidth * 0.25) - 25, (screenHeight * 0.5) - 25, 0.25)
    local childBox2 = display.newImageRect(lPanelGroup, "graphics/woman-8809430_640.jpg", (screenWidth * 0.25) - 25, (screenHeight * 0.5) - 25)
    test.anchorX = 0
    test.anchorY = 0
    test.x = 10
    test.y = 10
	
    childBox2.anchorX = 0
    childBox2.anchorY = 0
    childBox2.x = 10
    childBox2.y = 10
	
--    childBox2:setFillColor(0, 0, 1, 0.5)  -- Set semi-transparent green color for visibility
	lButton:setFillColor(0, .5, .5, 0.5)  -- Set semi-transparent green color for visibility

    local mainImage2 = display.newImageRect("npc/Val/val.png", 275, 275)
	mainImage2.x, mainImage2.y = display.contentCenterX, display.contentCenterY + 150
	
	local outlineRect = display.newRect(mainImage2.x, mainImage2.y, 110, 110)
	outlineRect:setFillColor(0, 0, 0, 0)
	outlineRect.strokeWidth = 5
	outlineRect:setStrokeColor(0, 0, 0.5)
	
	mainImage2:toFront()

    return {
        PanelGroup = lPanelGroup,
        LocationX = childBox2.x,
        LocationY = childBox2.y
    }
end

function scene:TestSlider()
	local widget = require( "widget" )
     
	-- Slider listener
	local function sliderListener( event )
		print( "Slider at " .. event.value .. "%" )
	end
	 
	-- Create the widget
	local slider = widget.newSlider(
		{
			x = display.contentCenterX,
			y = display.contentCenterY,
			width = 400,
			value = 10,  -- Start slider at 10% (optional)
			listener = sliderListener
		}
	)
end

local function OnDialogComplete(AResult)
	-- gamegui.ShowModalDialog()
	scene:DisplayInteractivePanel()
	scene:TestSlider()
end

-- Function to display a console with a background and an overlay image
local function DisplayConsole(parentGroup, backgroundPath, overlayPath)
    -- Load and display the background image
--    local background = display.newImageRect(parentGroup, "graphics/backgrounds/corona_up.png", 1280, 720)
    local background = display.newImageRect(parentGroup, "graphics/sci-fi-2992797_1920.jpg", 1280, 720)
	parentGroup:insert(background)
	
	background.x = display.contentCenterX
    background.y = display.contentCenterY
	npcdialog.DisplayDialog(parentGroup, "val", "val", OnDialogComplete)

    return {background = background}--, overlay = overlay}
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	_self = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	DisplayConsole(sceneGroup)
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end

-- destroy()
function scene:destroy( event )
	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
