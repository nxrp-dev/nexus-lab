unit csTileMap;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

const
  // --- field shifts ---
  cStateShift      = 0;    // bits 0..7
  cTraitShift      = 8;    // bits 8..15
  cSpriteShift     = 16;   // bits 16..23
  cTileTypeShift   = 24;   // bits 24..31
  cPayloadShift    = 32;   // bits 32..63

  // --- field masks (already shifted into position) ---
  cStateFieldMask    : TMapTile = TMapTile($FF) shl cStateShift;
  cTraitFieldMask    : TMapTile = TMapTile($FF) shl cTraitShift;
  cSpriteFieldMask   : TMapTile = TMapTile($FF) shl cSpriteShift;
  cTileTypeFieldMask : TMapTile = TMapTile($FF) shl cTileTypeShift;
  cPayloadFieldMask  : TMapTile = TMapTile($FFFFFFFF) shl cPayloadShift;

  // --- single-bit masks for states (convenience) ---
  cStateSeenMask       : TMapTile = TMapTile(1) shl (cStateShift + Ord(tsSeen));
  cStateVisibleMask    : TMapTile = TMapTile(1) shl (cStateShift + Ord(tsVisible));
  cStateHighlightedMask: TMapTile = TMapTile(1) shl (cStateShift + Ord(tsHighlighted));
  cStateDiscoveredMask : TMapTile = TMapTile(1) shl (cStateShift + Ord(tsDiscovered));

  // --- single-bit masks for traits (convenience) ---
  cTraitWalkableMask     : TMapTile = TMapTile(1) shl (cTraitShift + Ord(ttWalkable));
  cTraitTransparentMask  : TMapTile = TMapTile(1) shl (cTraitShift + Ord(ttTransparent));
  cTraitFlammableMask    : TMapTile = TMapTile(1) shl (cTraitShift + Ord(ttFlammable));
  cTraitLiquidMask       : TMapTile = TMapTile(1) shl (cTraitShift + Ord(ttLiquid));
  cTraitBlocksProjMask   : TMapTile = TMapTile(1) shl (cTraitShift + Ord(ttBlocksProjectiles));
  cTraitSlowsMoveMask    : TMapTile = TMapTile(1) shl (cTraitShift + Ord(ttSlowsMovement));


const
  cTileTypeFloor  = 0;
  cTileTypeWall   = 1;
  cTileTypeDoor   = 2;
  cTileTypeStairs = 3;


implementation

end.

