local const = {}

const.cPanelOptions =
{
    frames = {
        -- Top left corner
        { x = 0, y = 0, width = 50, height = 50 },
        -- Top middle
        { x = 50, y = 0, width = 297, height = 50 },
        -- Top right corner
        { x = 347, y = 0, width = 50, height = 50 },
        -- Left middle
        { x = 0, y = 50, width = 50, height = 278 },
        -- Middle
        { x = 50, y = 50, width = 297, height = 278 },
        -- Right middle
        { x = 347, y = 50, width = 50, height = 278 },
        -- Bottom left corner
        { x = 0, y = 328, width = 50, height = 50 },
        -- Bottom middle
        { x = 50, y = 328, width = 297, height = 50 },
        -- Bottom right corner
        { x = 347, y = 328, width = 50, height = 50 }
    }
}

const.cGameFont = "fonts/Elianto/Elianto-Regular.ttf"
const.cStarMapTileSize = 20
const.cStarCount = 100

return const