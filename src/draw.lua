NODE_TYPE = {
    TEXT = "text",
    RECTANGLE = "rectangle",
    CIRCLE = "circle",
}

DRAW_MODE = {
    FILL = "fill",
    LINE = "line"
}

local draw_actions = {
    [NODE_TYPE.TEXT] = function(node)
        local text = node.text
        local tr = node.transform
        local color = node.paint.color
        love.graphics.setColor(color.r, color.g, color.b, color.a)
        love.graphics.print(text.value, tr.position.x, tr.position.y, tr.rotation, tr.scale.x, tr.scale.y)
    end,
    [NODE_TYPE.RECTANGLE] = function(node)
        local tr = node.transform
        local color = node.paint.color
        local mode = node.paint.mode
        local angle = tr.rotation
        love.graphics.setColor(color.r, color.g, color.b, color.a)
        love.graphics.rotate(angle)
        love.graphics.rectangle(mode, tr.position.x, tr.position.y, tr.size.width, tr.size.height)
    end,
    [NODE_TYPE.CIRCLE] = function(node)
        local tr = node.transform
        local color = node.paint.color
        local mode = node.paint.mode
        local angle = tr.rotation
        love.graphics.setColor(color.r, color.g, color.b, color.a)
        love.graphics.rotate(angle)
        love.graphics.circle(mode, tr.position.x, tr.position.y, tr.radius)
    end
}

local function draw_node(node)

    -- If the node is not visible, return
    if not node.visible then
        return
    end

    -- If the node has children, traverse them recursively
    if node.children then
      for _, child in ipairs(node.children) do
        draw_node(child)
      end
    end

    -- Set default values for node properties
    node.transform = node.transform or {}
    node.transform.position = node.transform.position or { x = 0, y = 0 }
    node.transform.scale = node.transform.scale or { x = 1, y = 1 }
    node.transform.size = node.transform.size or { width = 0, height = 0 }
    node.transform.radius = node.transform.radius or 0
    node.transform.rotation = node.transform.rotation or 0
    node.paint = node.paint or {}
    node.paint.color = node.paint.color or COLOR.WHITE
    node.paint.mode = node.paint.mode or DRAW_MODE.FILL

    -- If the node has a draw action, execute it
    if draw_actions[node.type] then
        love.graphics.push()
        draw_actions[node.type](node)
        love.graphics.pop()
    end

end

function love.draw()

    -- set background color or default to black
    local bg_color = GLOBAL_STATE.bg_color or COLOR.BLACK
    love.graphics.setBackgroundColor(bg_color.r, bg_color.g, bg_color.b, bg_color.a)

    -- Draw the current scene
    draw_node(GLOBAL_STATE.current_scene)
 
end