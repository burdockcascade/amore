require("src.amore")

local scene = {
    type = "scene",
    visible = true,
    children = {
        {
            type = NODE_TYPE.CIRCLE,
            visible = true,
            paint = {
                color = COLOR.RED,
                mode = DRAW_MODE.LINE
            },
            transform = {
                position = { x = 400, y = 400 },
                radius = 100
            },
            events = {
                update = function(node, dt)
                    node.transform.rotation = (node.transform.rotation or 0) - 0.1
                end,
            }
        },
        {
            type = NODE_TYPE.RECTANGLE,
            visible = true,
            paint = {
                color = COLOR.GREEN
            },
            transform = {
                position = { x = 100, y = 100 },
                size = { width = 200, height = 200 }
            },
            events = {
                update = function(node, dt)
                    node.transform.rotation = (node.transform.rotation or 0) - 0.05
                end,
                keypressed = function(node, event)
                    node.visible = not node.visible
                end
            },
            children = {
                {
                    type = NODE_TYPE.TEXT,
                    visible = true,
                    text = {
                        value = "Hello World!",
                        size = 24
                    },
                    paint = {
                        color = COLOR.MAGENTA
                    },
                    transform = {
                        position = { x = 10, y = 10 },
                        scale = { x = 1, y = 1 }
                    },
                    events = {
                        update = function(node, dt)
                            node.text.value = love.system.getOS()
                        end
                    }
                }
            }
        },
        {
            type = NODE_TYPE.TEXT,
            visible = true,
            text = {
                value = "I'm a text node!",
                size = 96,
            },
            paint = {
                color = COLOR.BLUE
            },
            transform = {
                position = { x = 110, y = 110 },
                scale = { x = 4, y = 4 }
            },
            vars = {
                counter = 0
            },
            events = {
                update = function(node, dt)
                    node.vars.counter = node.vars.counter + dt
                    if node.vars.counter > 1 then
                        node.vars.counter = 0
                        node.visible = not node.visible
                    end
                end
            }
        }
    }
}

GLOBAL_STATE = {
    current_scene = scene
}