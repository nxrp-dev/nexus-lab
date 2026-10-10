local composer = require( "composer" )

local scene = composer.newScene()
local progressRing = require("progressRing")

local gamegui = require("gamegui")
local const = require("const")
local GameData = require("GameData")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
--local _TargetNameLabel

-- Main.lua

local widget = require("widget")

local musicTrack
local targetSound
local targetShiftSound

local _targetCursor
local _targetConsole
local _currentConsole

local function TileToPixel(AX, AY) 
	return {
		x = (AX * const.cStarMapTileSize), 
		y = (AY * const.cStarMapTileSize)
	}
end

local function BuildLabel(AParentView, AText, AX, AY)
	local lLabel = display.newText(AParentView, AText, AX, AY, const.cGameFont, 22 )
    lLabel.anchorX = 0
    lLabel.anchorY = 0
    lLabel:setFillColor( 0.82, 0.86, 1 )
	return lLabel
end

local function UpdateStarSystem(AConsole, AStarSystem)
	AConsole.NameLabel.text = "--[ Name: "..AStarSystem.Name..""
	AConsole.SizeLabel.text = "--[ Size: "..AStarSystem.Size.Name..""
	AConsole.SystemPressureLabel.text = "--[ Pressure: "..AStarSystem.SystemPressure.Name..""
	AConsole.PoliticalSystemLabel.text = "--[ Gov: "..AStarSystem.PoliticalSystem.Name..""
	AConsole.TechLevelLabel.text = "--[ Tech: "..AStarSystem.TechLevel.Name..""
--	AConsole.SpecialResourceLabel.text = "--[ Resource: "..AStarSystem.SpecialResource.Name..""
end

local function drawCircle(event)
	local lCircle = event.target
	local lStarSystem = lCircle.StarSystem
	local lPixelLoc = TileToPixel(lStarSystem.x, lStarSystem.y)
	if not _targetCursor then
		_targetCursor = display.newImageRect(lCircle.view, "graphics/Ship_Shop/Dot_02_02.png", const.cStarMapTileSize*3, const.cStarMapTileSize*3)
		-- start it at home
		local lHomeLoc = TileToPixel(GameData.CurrentSystem.x, GameData.CurrentSystem.y)
		_targetCursor.x = lHomeLoc.x
		_targetCursor.y = lHomeLoc.y
	end

	transition.to(_targetCursor, 
	{
		time=250, 
		rotation=180, 
		onComplete = function() 
			audio.play(targetShiftSound)
			transition.to(_targetCursor,
			{ 
				rotation=0, 
				time=250, 
				x=lPixelLoc.x, 
				y=lPixelLoc.y,
				onComplete = function()
					transition.to(_targetCursor, 
					{
						time=250, 
						rotation=360,
						onComplete = function()
							audio.play(targetSound)
						end
					})
				end
			})
		end
	})

	_targetConsole.SpecialResourceLabel.text = "--["..lStarSystem.x..","..lStarSystem.y.."]--["..lPixelLoc.x..","..lPixelLoc.y.."]--"
	UpdateStarSystem(_targetConsole, lStarSystem)
end

-- Drawing the starmap

local function drawStarmap(AStarGroup)
	for i, lStarSystem in ipairs(GameData.SectorMap.StarSystems) do
		local lPixelLoc = TileToPixel(lStarSystem.x, lStarSystem.y)
		local lSystem = display.newImageRect ( AStarGroup, "graphics/spaceobjects/14.png", const.cStarMapTileSize, const.cStarMapTileSize)
		lSystem.x = lPixelLoc.x
		lSystem.y = lPixelLoc.y
		
		lSystem:addEventListener( "tap", drawCircle )
		lSystem.StarSystem = lStarSystem
		lSystem.view = AStarGroup
		lStarSystem.view = AStarGroup
	end
end

local function BuildRightConsole(AParentView, ATitle, ATop)
	local lPart = gamegui.newPanel(AParentView, display.contentWidth * 0.75, ATop, display.contentWidth * 0.25, display.contentHeight * 0.50)
	
	lPart.TitleLabel = BuildLabel(lPart, "--[ "..ATitle.." ]--", 30, 30)
    lPart.TitleLabel:setFillColor( 0.0, 0.0, 1 )

	lPart.NameLabel = BuildLabel(lPart, "--[ Name: ]--", 30, 60)
    lPart.SizeLabel = BuildLabel(lPart, "--[ Size: ]--", 30, 90)

	lPart.SystemPressureLabel = BuildLabel(lPart, "--[ Pressure: ]--", 30, 120)
	lPart.PoliticalSystemLabel = BuildLabel(lPart, "--[ Government: ]--", 30, 150)
	lPart.TechLevelLabel = BuildLabel(lPart, "--[ Technology: ]--", 30, 180)
	lPart.SpecialResourceLabel = BuildLabel(lPart, "--[ Resource: ]--", 30, 210)

	return lPart
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	GameData.NewGame()

	musicTrack = audio.loadStream("audio/SciFiTactics/Ambiance_Dark_Electronic_11.wav")
    targetSound = audio.loadSound("sfx/target_2.wav") --"audio/ScifiTactics/UI_Mouseover_21.wav" )
	targetShiftSound = audio.loadSound("sfx/holoshift.wav") --"audio/ScifiTactics/UI_Mouseover_21.wav" )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
   
    local lBackground = display.newImageRect( sceneGroup, "graphics/background/geometric-art-7441985_1920.jpg", display.contentWidth, display.contentHeight )
    lBackground.anchorX, lBackground.anchorY = 0, 0
    local lStarMap = gamegui.newMapPanel(sceneGroup, 0, 0, display.contentWidth * 0.75, display.contentHeight, const.cStarMapTileSize, 54, 54, "graphics/backgrounds/corona_up.png")

	_currentConsole = BuildRightConsole(sceneGroup, "Current System", 0)
	_targetConsole = BuildRightConsole(sceneGroup, "Target System", display.contentHeight * 0.50)

	UpdateStarSystem(_currentConsole, GameData.CurrentSystem)

	local lLoc = TileToPixel(GameData.CurrentSystem.x, GameData.CurrentSystem.y)
	lLocalRange = display.newCircle(lStarMap, lLoc.x, lLoc.y, const.cStarMapTileSize * 10)
	lLocalRange:setFillColor( 0, .5, .5, .15 )

    local lShipShop = display.newImageRect(_currentConsole, "graphics/Ship_Parts/Ship_3_1_BTN.png", 80, 80)
	lShipShop.x = 65
	lShipShop.y = 300
    --lShipShop:setFillColor( 0.0, 0.0, .75 )

    local lCargo = display.newImageRect(_currentConsole, "graphics/Buttons/BTNs/Hangar_BTN.png", 80, 80)
	lCargo.x = 155
	lCargo.y = 300
--    lCargo:setFillColor(0, .75, .5, .75)

    local lCargo = display.newImageRect(_targetConsole, "graphics/Ship_Parts/Upgrade_BTN.png", 80, 80)
	lCargo.x = 65
	lCargo.y = 300
--    lCargo:setFillColor(0, .75, .5, .75)

	
	drawStarmap(lStarMap)
end


-- show()
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
