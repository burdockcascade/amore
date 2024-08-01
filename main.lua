require("src.amore")

local resources = {
    fonts = {
        bombing = { path = "assets/Bombing.ttf" },
        playfair = { path = "assets/PlayfairDisplay-Regular.ttf" }
    },
    images = {
        love2dwhale = { path = "assets/love2dwhale.png" }
    },
    spritesheets = {
        simcity_terrain = { 
            path = "assets/terrain.png",
            dimensions = { width = 128, height = 256 },
            divisions = { rows = 15, columns = 8 }
        },
        hero2d = {
            path = "assets/2dhero.png",
            dimensions = { width = 640, height = 470 },
            divisions = { rows = 5, columns = 8 }
        }
    }
}

local flashy_rect = {
    type = "rectangle",
    visible = true,
    paint = {
        color = COLOR.WHITE,
        mode = DRAW_MODE.FILL,
    },
    transform = {
        position = { x = 175, y = 150 },
        size = { width = 200, height = 200 },
        origin = { x = 100, y = 100 },
        rotation = 0.02
    },
    vars = {
        counter = 0,
        interval = 1
    },
    events = {
        update = function(app, node, dt)
            node.transform.rotation = node.transform.rotation + 0.02
            node.vars.counter = node.vars.counter + dt
            if node.vars.counter > node.vars.interval then
                node.vars.counter = 0
                node.paint.color = COLOR.RANDOM()
            end
        end,
    },
    children = {
        {
            type = "rectangle",
            visible = true,
            paint = {
                color = COLOR.RED,
                mode = DRAW_MODE.FILL,
            },
            transform = {
                position = { x = 50, y = 10 },
                size = { width = 100, height = 100 },
            },
            vars = {
                counter = 0,
                interval = 0.5
            },
            events = {
                update = function(app, node, dt)
                    node.vars.counter = node.vars.counter + dt
                    if node.vars.counter > node.vars.interval then
                        node.vars.counter = 0
                        node.paint.color = COLOR.RANDOM()
                    end
                end
            },
            children = {
                {
                    type = "rectangle",
                    visible = true,
                    paint = {
                        color = COLOR.WHITE,
                        mode = DRAW_MODE.FILL,
                    },
                    transform = {
                        position = { x = 10, y = 10 },
                        size = { width = 80, height = 80 },
                    },
                    vars = {
                        counter = 0,
                        interval = 0.25
                    },
                    events = {
                        update = function(app, node, dt)
                            node.vars.counter = node.vars.counter + dt
                            if node.vars.counter > node.vars.interval then
                                node.vars.counter = 0
                                node.paint.color = COLOR.RANDOM()
                            end
                        end
                    },
                }
            }
        }
    }
}

local love_whale = {
    type = "scene",
    visible = true,
    transform = {
        position = { x = 300, y = 300 },
    },
    children = {
        {
            type = "sprite",
            notes = "fixme: rotation point",
            visible = true,
            paint = {
                texture = "love2dwhale",
            },
            transform = {
                origin = { x = 174/2, y = 174/2 },
                rotation = 0.01
            },
            events = {
                update = function(app, node, dt)
                    node.transform.rotation = node.transform.rotation + 0.01
                end
            },
        },
        {
            type = "text",
            visible = true,
            paint = {
                color = COLOR.RED,
            },
            text = {
                value = "Love2D Whale",
                font = "playfair",
                size = 20,
            },
        }
    },
}

local spinning_rect = {
    type = "scene",
    visible = true,
    transform = {
        position = { x = 500, y = 400 },
    },
    children = {
        {
            name = "Rotating Rectangle",
            type = "rectangle",
            visible = true,
            paint = {
                color = COLOR.RANDOM(),
                mode = DRAW_MODE.FILL,
            },
            transform = {
                position = { x = 10, y = 10 },
                size = { width = 200, height = 200 },
                origin = { x = -100, y = -100 },
                rotation = 0.01
            },
            timers = {
                {
                    interval = 5,
                    callback = function(app, node, dt)
                        node.paint.color = COLOR.RANDOM()
                    end
                }
            },
            events = {
                update = function(app, node, dt)
                    node.transform.rotation = (node.transform.rotation or 0) - 0.01
                end
            },
            children = {
                {
                    type = "text",
                    visible = true,
                    text = {
                        value = "Hello World!"
                    },
                    paint = {
                        color = COLOR.WHITE,
                    },
                    transform = {
                        position = { x = 100, y = 100 },
                        origin = { x = 50, y = 50 },
                        rotation = 0.1
                    },
                    timers = {
                        {
                            interval = 3,
                            callback = function(app, node)
                                node.paint.color = COLOR.RANDOM()
                            end
                        }
                    },
                    events = {
                        update = function(app, node, dt)
                            node.transform.rotation = (node.transform.rotation or 0) - 0.01
                        end
                    },
                }
            }
        }
    }
}

local blinking_text = {
    name = "Blinking Text",
    type = "text",
    visible = true,
    text = {
        value = "Love2D",
        font = "bombing",
        size = 150,
    },
    paint = {
        color = COLOR.RANDOM(),
    },
    transform = {
        position = { x = 100, y = 200 }
    },
    timers = {
        {
            interval = 1,
            callback = function(app, node)
                node.visible = not node.visible
            end
        }
    }
}

local hud = {
    name = "Heads up display",
    type = "text",
    visible = true,
    text = {
        value = "Hello Mouse!"
    },
    paint = {
        color = COLOR.WHITE,
    },
    transform = {
        position = { x = 10, y = 10 }
    },
    events = {
        update = function(app, node, dt)
            local x, y = love.mouse.getPosition()
            node.text.value = "Mouse position: " .. x .. ", " .. y
        end
    }
}

-- Start the scene
START(resources, {
    type = "scene",
    visible = true,
    bg_color = COLOR.RANDOM(),
    vars = {
        counter = 0,
        interval = 1
    },
    timers = {
        {
            interval = 1,
            callback = function(app, node)
                node.bg_color = COLOR.RANDOM()
            end
        }
    },
    children = {
        flashy_rect,
        love_whale,
        spinning_rect,
        hud,
    }
})