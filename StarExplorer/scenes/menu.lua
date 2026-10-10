
local composer = require( "composer" )
local galaxy = require("galaxy")
local scene = composer.newScene()
local json = require( "json" )
local gamegui = require("gamegui")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local musicTrack

-- Function to display a console with a background and an overlay image
local function DisplayConsole(parentGroup, backgroundPath, overlayPath)
    -- Load and display the background image
--    local background = display.newImageRect(parentGroup, "graphics/backgrounds/corona_up.png", 1280, 720)
    local background = display.newImageRect(parentGroup, "graphics/fantasy-2861815_1280.jpg", 1280, 720)

	background.x = display.contentCenterX
    background.y = display.contentCenterY

    return {background = background}--, overlay = overlay}
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	DisplayConsole(sceneGroup)
--	gamegui.DisplayInteractivePanel(sceneGroup)

    local title = display.newImageRect( sceneGroup, "title.png", 500, 80 )
    title.x = display.contentCenterX+200
    title.y = 50

	gamegui.DrawSceneButton(sceneGroup, "New Game", 10, 10, "SectorMap")
	gamegui.DrawSceneButton(sceneGroup, "Load Game", 65, 10, "highscores")
	gamegui.DrawCutSceneButton(sceneGroup, "Leaderboard", 120, 10, "landing")
	gamegui.DrawSceneButton(sceneGroup, "Create Player", 175, 10, "newgame")

    -- Win64 native-plugin proof, added only to this copied project.
    local pluginOK, pluginMessage = pcall(function()
        package.cpath = system.pathForFile("", system.ResourceDirectory) .. "\\?.dll;" .. package.cpath
        local sample = require("plugin.sample")
        local plugin = sample.new()
        local answer = plugin:Add(20, 22)
        local greeting = plugin:Greeting("StarExplorer")
        assert(answer == 42, "Pascal Add returned " .. tostring(answer))
        assert(greeting == "Hello, StarExplorer from Pascal", "Unexpected Pascal greeting: " .. tostring(greeting))
        return "Pascal Add(20, 22) = " .. answer .. "\n" .. greeting
    end)

    print("Win64 plugin proof:", pluginOK and "PASS" or "FAIL", pluginMessage)

    local proofY = display.contentCenterY + 210
    local proofWidth = math.min(display.contentWidth - 40, 900)
    local background = display.newRoundedRect(sceneGroup,
        display.contentCenterX, proofY, proofWidth, 120, 14)
    background:setFillColor(0.02, 0.05, 0.09, 0.94)
    background.strokeWidth = 4
    if pluginOK then
        background:setStrokeColor(0.15, 0.9, 0.35)
    else
        background:setStrokeColor(0.95, 0.2, 0.2)
    end

    local label = (pluginOK and "WIN64 PASCAL PLUGIN: PASS\n" or
        "WIN64 PASCAL PLUGIN: FAIL\n") .. tostring(pluginMessage)
    local result = display.newText({ parent = sceneGroup, text = label,
        x = display.contentCenterX, y = proofY,
        width = proofWidth - 24, height = 100,
        font = native.systemFontBold, fontSize = 22, align = "center" })
    result:setFillColor(1, 1, 1)

	--"leonell-cassio-the-sapphire-city-10450.mp3"
    musicTrack = audio.loadStream("audio/leonell-cassio-the-sapphire-city-10450.mp3") --"audio/ScifiTactics/Ambiance_Dark_Electronic_11.wav")	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		audio.play( musicTrack, { channel=1, loops=-1 } )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		audio.stop( 1 )
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
