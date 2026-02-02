unit tpTileMap;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  TMapTile = UInt64;
  TTileStateMask = UInt64;
  TMapField = array of TMapTile;

type
  // --- bit positions for 8 "state" flags (dynamic) ---
  TTileState = (
    tsSeen = 0,            // player has seen this tile before (fog memory)
    tsVisible = 1,         // currently visible to player (this turn)
    tsHighlighted = 2,     // UI: cursor/target highlight (optional)
    tsDiscovered = 3,      // e.g., secret revealed / identified (optional)
    tsReserved4 = 4,
    tsReserved5 = 5,
    tsReserved6 = 6,
    tsReserved7 = 7
  );

  // --- bit positions for 8 "trait" flags (more "property") ---
  TTileTrait = (
    ttWalkable = 0,
    ttTransparent = 1,
    ttFlammable = 2,
    ttLiquid = 3,
    ttBlocksProjectiles = 4,  // optional
    ttSlowsMovement = 5,      // optional
    ttReserved6 = 6,
    ttReserved7 = 7
  );


implementation

end.

