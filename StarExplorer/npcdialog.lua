local npcdialog = {}

local json = require( "json" )
local gamegui = require("gamegui")

local _dialogNodes = {}
local _OnCompleteDialog

local function DisplayWireframe(AParentView)
    if AParentView.WireframeGroup then
        AParentView.WireframeGroup:removeSelf()
        AParentView.WireframeGroup = nil
    end

    AParentView.WireframeGroup = display.newGroup()
    AParentView:insert(AParentView.WireframeGroup)

    -- kill background clickiness
    -- Create a semi-transparent background
    local background = display.newRect(AParentView.WireframeGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    background:setFillColor(0, 0, 0, .50)  -- Semi-transparent black

    -- Prevent touch events from passing through the background
    background:addEventListener("touch", function() return true end)
    background:addEventListener("tap", function() return true end)

    local lPortrait = gamegui.newPortrait(AParentView.WireframeGroup, 0, 0, 275, 275, _dialogNodes.npc.image)
    local lTextBox = gamegui.newPanel(AParentView.WireframeGroup, lPortrait.x + lPortrait.width, lPortrait.y, display.contentWidth - lPortrait.width, lPortrait.height)
    local lTest = gamegui.newTextPanel(AParentView.WireframeGroup, lPortrait.x + lPortrait.width, lPortrait.y, display.contentWidth - lPortrait.width, lPortrait.height)
	-- Text settings
--	local options = {
--		text = "",
--		x = lTextBox.x+475,
--		y = lTextBox.y+(32*2),
--		width = lTextBox.width-100, -- Specify the width for the text box
--		font = "fonts/Elianto/Elianto-Regular.ttf", -- Choose your font
--		fontSize = 32, -- Set font size
--		align = "left", -- Alignment: "left", "center", or "right"
--        height = lTextBox.x
--	}

	-- Create the text object
--	local wrappedText = display.newText(options)
--    wrappedText.anchorX = 0
--    wrappedText.anchorY = 0
--    wrappedText.x = lTextBox.x+40
--    wrappedText.y = lTextBox.y+40
--	wrappedText:setFillColor(1, 1, 1)
--	AParentView.WireframeGroup:insert(wrappedText)

    AParentView.WireframeGroup:insert(lTest)

	local lAnswerBox = gamegui.newPanel(AParentView.WireframeGroup, lPortrait.x, lPortrait.y + lPortrait.height, display.contentWidth, display.contentHeight - lPortrait.height)
	AParentView.WireframeGroup:insert(lAnswerBox)

    return {
        QuestionLabel = wrappedText,
        AnswerBox = lAnswerBox,
        AnswerX = lPortrait.x,
        AnswerY = lAnswerBox.y+15,
        WireframeGroup = AParentView.WireframeGroup,
    }    
end;

local function CloseWireframe(AParentWindow) 
    if AParentWindow.WireframeGroup.dialogGroup then
        AParentWindow.WireframeGroup.dialogGroup:removeSelf()
        AParentWindow.WireframeGroup.dialogGroup = nil
    end
end

local function displayDialog(sceneGroup, AWireframe, node)
    if sceneGroup.WireframeGroup.dialogGroup then
        sceneGroup.WireframeGroup.dialogGroup:removeSelf()
        sceneGroup.WireframeGroup.dialogGroup = nil
    end
    
    local dialogGroup = display.newGroup()
    sceneGroup.WireframeGroup:insert(dialogGroup)
    sceneGroup.WireframeGroup.dialogGroup = dialogGroup
    
        
    sceneGroup.WireframeGroup.QuestionLabel.text = node.question.text;
    --AWireframe.QuestionLabel.text = node.question.text;
    if node.question.audio then
        media.stopSound()
        media.playSound("npc/val/"..node.question.audio)
    end

    -- Display answers
    if #node.answers > 0 then
        for i, answer in ipairs(node.answers) do
            local answerButton = display.newText({
                parent = dialogGroup,
                anchorX = 0,
                anchorY = 0,
                text = answer.text,
                x = 220,
                y = (AWireframe.AnswerY + 32) + (i - 1) * 40,
                width = 800,  -- should be width of the answerbox
                font = "fonts/Elianto/Elianto-Regular.ttf",
                fontSize = 32,
                align = "left"
            })
            answerButton:setFillColor(1, 1, 1)
            answerButton:addEventListener("tap", function()
                if answer.audio then
                    media.stopSound()
                    media.playSound("npc/val/"..answer.audio)
                end
                if answer.nextNode then
                    local nextNode = answer.nextNode
                    if type(nextNode) == "string" then
                        nextNode = _dialogNodes[nextNode]
                    end
                    displayDialog(sceneGroup, AWireframe, nextNode)
                else
                    if sceneGroup.WireframeGroup then
                        sceneGroup.WireframeGroup:removeSelf()
                        sceneGroup.WireframeGroup = nil
                    end
                    if _OnCompleteDialog then
                        _OnCompleteDialog()
                    end
                end
            end)
        end
    else
        if sceneGroup.WireframeGroup then
            sceneGroup.WireframeGroup:removeSelf()
            sceneGroup.WireframeGroup = nil
        end
        if _OnCompleteDialog then
            _OnCompleteDialog()
        end
    end
end

local function LoadNPC(ANPC, ADialogConfig)
    local lPath = system.pathForFile( "npc/"..ANPC.."/"..ADialogConfig..".json", system.ResourceDirectory)
    local file = io.open(lPath, "r" )
 
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        _dialogNodes = json.decode( contents )
    end
end

function npcdialog.DisplayDialog(AParentView, ANPC, ADialogConfig, AOnCompleteDialog)
    LoadNPC(ANPC, ADialogConfig)
    _OnCompleteDialog = AOnCompleteDialog
    local lWireframe = DisplayWireframe(AParentView)
    displayDialog(AParentView, lWireframe, _dialogNodes.start)
end

return npcdialog