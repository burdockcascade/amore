local function notify_node(node, event, data)

    -- If the node has children, traverse them recursively
    if node.children then
      for _, child in ipairs(node.children) do
        notify_node(child, event, data)
      end
    end

    -- Call event if it exists
    if node.events and node.events[event] then
        node.events[event](node, data)
    end

end

function love.load(arg, unfilteredArg)
  notify_node(GLOBAL_STATE.current_scene, "load", {arg = arg, unfilteredArg = unfilteredArg})
end

function love.update(dt)
  notify_node(GLOBAL_STATE.current_scene, "update", dt)
end

function love.keypressed(key, unicode)
  notify_node(GLOBAL_STATE.current_scene, "keypressed", {key = key, unicode = unicode})
end

function love.keyreleased(key, unicode)
  notify_node(GLOBAL_STATE.current_scene, "keyreleased", {key = key, unicode = unicode})
end

function love.mousepressed(x, y, button)
  notify_node(GLOBAL_STATE.current_scene, "mousepressed", {x = x, y = y, button = button})
end

function love.mousereleased(x, y, button)
  notify_node(GLOBAL_STATE.current_scene, "mousereleased", {x = x, y = y, button = button})
end

function love.mousemoved(x, y, dx, dy)
  notify_node(GLOBAL_STATE.current_scene, "mousemoved", {x = x, y = y, dx = dx, dy = dy})
end