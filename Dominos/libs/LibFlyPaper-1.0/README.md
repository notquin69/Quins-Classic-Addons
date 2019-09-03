# FlyPaper
A library for sticking frames together

## Examples:

```lua
local LibFlyPaper = LibStub("LibFlyPaper-1.0")

-- Attempts to attach <frame> to <otherFrame>
-- tolerance: how close the frames need to be to attach
-- xOff: horizontal spacing to include between each frame
-- yOff: vertical spacing to include between each frame
-- returns an anchor point if attached and nil otherwise
local anchorPoint = LibFlyPaper.Stick(frame, otherFrame, tolerance, xOff, yOff)

-- Attempts to anchor frame to a specific anchor point on otherFrame
-- point: any non nil return value of LibFlyPaper.Stick
-- xOff: horizontal spacing to include between each frame
-- yOff: vertical spacing to include between each frame
-- returns an anchor point if attached and nil otherwise
local anchorPoint = LibFlyPaper.StickToPoint(frame, otherFrame, point, xOff, yOff)
```
