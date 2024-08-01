-- Seed random number generator
math.randomseed(os.time())

APP = {
    resources = {},
    scene = {},
}

function APP:get_font(name, size)

    local font = self.resources.fonts[name]

    if not font then
        error("Font not found: " .. name)
        return
    end

    -- Create cached fonts table
    font.cached = font.cached or {}

    -- Get cached or create new font
    if not font.cached[size] then
        print("Creating font: " .. name .. " size: " .. size)
        font.cached[size] = love.graphics.newFont(font.path, size)
    end

    return font.cached[size]
end

function APP:get_image(name, path)

    if not self.resources.images[name] then
        error("Image not found: " .. name)
        return
    end

    if not self.resources.images[name].cached then
        print("Creating image: " .. name)
        local img = love.graphics.newImage(self.resources.images[name].path)

        self.resources.images[name].height = img:getHeight()
        self.resources.images[name].width = img:getWidth()
        self.resources.images[name].cached = img

    end

    return self.resources.images[name].cached
end

--------------------------------------------------------------------------------
-- COLORS

COLOR = {
    BLACK = { r = 0.0, g = 0.0, b = 0.0, a = 1.0 },
    WHITE = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 },
    RED = { r = 1.0, g = 0.0, b = 0.0, a = 1.0 },
    GREEN = { r = 0.0, g = 1.0, b = 0.0, a = 1.0 },
    BLUE = { r = 0.0, g = 0.0, b = 1.0, a = 1.0 },
    YELLOW = { r = 1.0, g = 1.0, b = 0.0, a = 1.0 },
    CYAN = { r = 0.0, g = 1.0, b = 1.0, a = 1.0 },
    MAGENTA = { r = 1.0, g = 0.0, b = 1.0, a = 1.0 },
    GOLD = { r = 1.0, g = 0.843, b = 0.0, a = 1.0 },
    BRONZE = { r = 0.804, g = 0.498, b = 0.196, a = 1.0 },
    SILVER = { r = 0.753, g = 0.753, b = 0.753, a = 1.0 },
    RANDOM = function()
        return { r = math.random(), g = math.random(), b = math.random(), a = 1.0 }
    end,
}

--------------------------------------------------------------------------------
-- DRAW

DRAW_MODE = {
    FILL = "fill",
    LINE = "line"
}

local draw_actions = {}

-- Draw rectangle
function draw_actions.rectangle(node)
    love.graphics.rectangle(node.paint.mode, 0, 0, node.transform.size.width, node.transform.size.height)
end

-- Draw circle
function draw_actions.circle(node)
    love.graphics.circle(node.paint.mode, 0, 0, node.transform.radius)
end

-- Draw text
function draw_actions.text(node)
    if node.text.font and APP.resources.fonts then
        love.graphics.print(node.text.value, APP:get_font(node.text.font, node.text.size))
    else
        love.graphics.print(node.text.value)
    end
end

function draw_actions.scene(node)
    -- Do nothing
end

function draw_actions.sprite(node)
    if node.paint and node.paint.texture and APP.resources.images then
        local img = APP:get_image(node.paint.texture)
        love.graphics.draw(img, 0, 0)
    end
end

local function draw_node(node)

    -- If the node is not visible, return
    if not node.visible then
        return
    end

    -- Set default transform values
    node.transform = node.transform or {}
    node.transform.position = node.transform.position or { x = 0, y = 0 }
    node.transform.scale = node.transform.scale or { x = 1, y = 1 }
    node.transform.size = node.transform.size or { width = 0, height = 0 }
    node.transform.radius = node.transform.radius or 0
    node.transform.rotation = node.transform.rotation or 0
    node.transform.origin = node.transform.origin or { x = 0, y = 0 }
    node.transform.skew = node.transform.skew or { x = 0, y = 0 }

    -- Create local transform
    local loveTransform = love.math.newTransform(
        node.transform.position.x,
        node.transform.position.y,
        node.transform.rotation,
        node.transform.scale.x,
        node.transform.scale.y,
        node.transform.origin.x,
        node.transform.origin.y,
        node.transform.skew.x,
        node.transform.skew.y
    )

    -- If the node has a draw action, execute it
    if draw_actions[node.type] then

        -- Apply paint color
        if node.paint and node.paint.color then
            love.graphics.setColor(node.paint.color.r, node.paint.color.g, node.paint.color.b, node.paint.color.a)
        end

        -- Apply the local transform
        love.graphics.push()
        love.graphics.applyTransform(loveTransform)

        -- Execute the draw action
        draw_actions[node.type](node)

        -- If the node has children, traverse them recursively
        if node.children then
            for _, child in ipairs(node.children) do
                draw_node(child)
            end
        end

        -- Reset the color
        love.graphics.setColor(1, 1, 1, 1)

        -- Reset the transform
        love.graphics.pop()

    end

end

function love.draw()

    -- set background color or default to black
    local bg_color = APP.scene.bg_color or COLOR.BLACK
    love.graphics.setBackgroundColor(bg_color.r, bg_color.g, bg_color.b, bg_color.a)

    -- Draw the current scene
    draw_node(APP.scene)
 
end

--------------------------------------------------------------------------------
-- EVENTS

-- Recursive function to notify nodes of events
function APP.notify_node(node, event, data)

    -- if the node has a timer, update it
    if event == "update" and node.timers then
        for _, timer in ipairs(node.timers) do
            timer.counter = (timer.counter or 0) + data
            if timer.counter >= timer.interval then
                timer.callback(APP, node, timer.counter)
                timer.counter = 0
            end
        end
    end

    -- Call event if it exists
    if node.events and node.events[event] then
        node.events[event](APP, node, data)
    end

    -- If the node has children, traverse them recursively
    if node.children then
        for _, child in ipairs(node.children) do
            APP.notify_node(child, event, data)
        end
    end

end

-- Function to send events to the scene
function APP.send_event(event, data)
    APP.notify_node(APP.scene, event, data)
end

function love.load(arg, unfilteredArg)
    APP.send_event("load", {arg = arg, unfilteredArg = unfilteredArg})
end

function love.update(dt)
    APP.send_event("update", dt)
end

function love.keypressed(key, unicode)
    APP.send_event("keypressed", {key = key, unicode = unicode})
end

function love.keyreleased(key, unicode)
    APP.send_event("keyreleased", {key = key, unicode = unicode})
end

function love.mousepressed(x, y, button)
    APP.send_event("mousepressed", {x = x, y = y, button = button})
end

function love.mousereleased(x, y, button)
    APP.send_event("mousereleased", {x = x, y = y, button = button})
end

function love.mousemoved(x, y, dx, dy)
    APP.send_event("mousemoved", {x = x, y = y, dx = dx, dy = dy})
end

--------------------------------------------------------------------------------
-- START

function START(resources, scene)

    -- merge resources
    APP.resources = resources or {}
    APP.resources.images = APP.resources.images or {}
    APP.resources.fonts = APP.resources.fonts or {}

    APP.scene = scene
end