# Amore

## Status
This project is in the early stages of development. It is not yet ready for use.

## Description
Amore is a simple 2D game engine built on top of Love2D. It is designed to be simple and easy to use, while still providing a lot of flexibility.

## Example
```lua
local resources = {
    images = {
        love2dwhale = { path = "assets/love2dwhale.png" }
    }
}

local love_whale = {
    type = "sprite",
    visible = true,
    paint = {
        texture = "love2dwhale",
    },
    transform = {
        position = { x = 300, y = 300 },
        origin = { x = 174/2, y = 174/2 }
    },
    events = {
        update = function(app, node, dt)
            node.transform.rotation = (node.transform.rotation or 0) + 0.01
        end
    }
}

START(resources, love_whale)
```