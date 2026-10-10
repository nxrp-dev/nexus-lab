
local composer = require( "composer" )
local json = require( "json" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

_cutScene = nil
local musicTrack

CutName = ""
local function LoadCutScene()
    local lPath = system.pathForFile( "cut/"..scene.CutName.."/cut.json", system.ResourceDirectory)
    local file = io.open(lPath, "r" )
 
    if file then
        local contents = file:read( "*a" )
        io.close( file )
--        scene._cutScene = json.decode( contents )
        return json.decode( contents )
    end
end

local function PlayChapter(AView, AChapter, ACutScene)
    if AChapter.image then
        local background = display.newImageRect( AView, "cut/"..scene.CutName.."/"..AChapter.image, display.contentWidth, display.contentHeight)
    end

    --media.playSound("cut/"..self.CutName.."/"..AChapter.audio)
--    media.playSound("cut/"..self.CutName.."/"..AChapter.audio)
--    media.playSound("cut/"..self.CutName.."/"..AChapter.audio)
    if AChapter.music then
        musicTrack = audio.loadStream("cut/"..scene.CutName.."/"..AChapter.music) --"audio/ScifiTactics/Ambiance_Dark_Electronic_11.wav")	
    end

    media.stopSound()
    if AChapter.audio then
        media.playSound("cut/"..scene.CutName.."/"..AChapter.audio, 
            function()
                if AChapter.nextChapter then
                    PlayChapter(AView, ACutScene[AChapter.nextChapter], ACutScene)
                end
                print("it completed")
            end
        )
    end

--    "animation": "",
--    "text": "",
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
    -- Access the custom property here
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
    print("Test")

	if ( phase == "will" ) then
        if self.CutName then
            print("Test3")
            -- Start Music
            print("Custom Property:", self.CutName)
        end
            -- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
        print("1")
        if not _cutScene then
            print("2")
            _cutScene = LoadCutScene()
        end
        audio.play( musicTrack, { channel=1, loops=-1 } )
        print("3")
        if _cutScene then
            local lChapter = _cutScene["start"]
            PlayChapter(sceneGroup, lChapter, _cutScene)
--            print("4")
  --          while lChapter do
    --            print("5")
      --          PlayChapter(sceneGroup, lChapter)
        --        if lChapter.nextChapter then
          --          lChapter = nil
            --        lChapter = lCutScene[lChapter.nextchapter]
              --  end
           -- end
        end

        -- Code here runs when the scene is entirely on screen
        -- foreach on each chapter
          -- Load First Image/Animation
            -- Load First Audio
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
